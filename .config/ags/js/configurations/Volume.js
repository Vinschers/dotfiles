import icons from "../icons.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Pango10 from "gi://Pango";
import { Menu } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";

const getAudioTypeIcon = (icon) => {
    const substitues = [
        ["audio-headset-bluetooth", icons.audio.type.headset],
        ["audio-card-analog-usb", icons.audio.type.speaker],
        ["audio-card-analog-pci", icons.audio.type.card],
    ];

    for (const [from, to] of substitues) {
        if (from === icon) return to;
    }

    return icon;
};

/** @param {'speaker' | 'microphone'=} type */
const VolumeIndicator = (type = "speaker") =>
    Widget.Button({
        cursor: "pointer",
        class_name: "slider-tooltip",
        on_clicked: () => {
            //@ts-ignore
            Audio[type].is_muted = !Audio[type].is_muted;
        },
        child: Widget.Icon({}).hook(
            Audio,
            (icon) => {
                if (Audio[type]) {
                    icon.icon =
                        type === "speaker"
                            ? getAudioTypeIcon(
                                  //@ts-ignore
                                  Audio[type].icon_name || "",
                              )
                            : icons.audio.mic.unmuted;

                    icon.tooltip_text = `Volume ${Math.floor(
                        //@ts-ignore
                        Audio[type].volume * 100,
                    )}%`;
                }
            },
            `${type}-changed`,
        ),
    });

/** @param {'speaker' | 'microphone'=} type */
const VolumeSlider = (type = "speaker") =>
    Widget.Slider({
        class_names: ["slider-box", "volume-slider"],
        draw_value: false,
        //@ts-ignore
        on_change: ({ value }) => (Audio[type].volume = value),
    }).hook(
        Audio,
        (slider) => {
            slider.value = Audio[type]?.volume || 0;
        },
        `${type}-changed`,
    );

export const Volume = () =>
    Widget.Box({
        class_name: "volume-box",
        spacing: 16,
        children: [
            VolumeIndicator("speaker"),
            VolumeSlider("speaker"),
            Widget.Box({
                vpack: "center",
                child: Widget.Button({
                    cursor: "pointer",
                    child: Widget.Icon({
                        icon: icons.audio.type.headset,
                    }),
                    on_clicked: () => App.toggleWindow("sink-selector"),
                }),
            }),
            Widget.Box({
                vpack: "center",
                child: Widget.Button({
                    cursor: "pointer",
                    child: Widget.Icon({
                        icon: icons.audio.mixer,
                    }),
                    on_clicked: () => App.toggleWindow("app-mixer"),
                }),
            }).hook(Audio, (box) => {
                box.visible = Audio.apps.length > 0;
            }),
        ],
    });

export const VolMicrophone = () =>
    Widget.Box({
        class_name: "volmicrophone-box",
        spacing: 16,
        children: [VolumeIndicator("microphone"), VolumeSlider("microphone")],
    }).hook(Audio, (box) => {
        box.visible = Audio.recorders.length > 0 || Audio.microphones.length > 0;
    });

/** @param {import('types/service/audio').Stream} stream */
const MixerItem = (stream) =>
    Widget.Box({
        hexpand: true,
        class_name: "mixer-item horizontal",
        spacing: 16,
        children: [
            Widget.Icon({
                binds: [["tooltipText", stream, "name"]],
            }).hook(stream, (icon) => {
                icon.icon = Utils.lookUpIcon(stream.name || "")
                    ? stream.name || ""
                    : icons.mpris.fallback;
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Widget.Label({
                        xalign: 0,
                        truncate: "end",
                        binds: [["label", stream, "description"]],
                        max_width_chars: 60,
                        ellipsize: Pango10.EllipsizeMode.END,
                    }),
                    Widget.Slider({
                        hexpand: true,
                        draw_value: false,
                        binds: [["value", stream, "volume"]],
                        on_change: ({ value }) => (stream.volume = value),
                    }),
                ],
            }),
            Widget.Label({
                xalign: 1,
            }).hook(stream, (label) => {
                label.label = `${Math.floor(stream.volume * 100)}%`;
            }),
        ],
    });

/** @param {import('types/service/audio').Stream} stream */
const SinkItem = (stream) =>
    Widget.Button({
        cursor: "pointer",
        hexpand: true,
        on_clicked: () => (Audio.speaker = stream),
        child: Widget.Box({
            children: [
                Widget.Icon({
                    icon: getAudioTypeIcon(stream.icon_name || ""),
                    tooltip_text: stream.icon_name,
                }),
                Widget.Label(
                    (stream.description || "").split(" ").slice(0, 4).join(" "),
                ),
                Widget.Icon({
                    icon: icons.tick,
                    hexpand: true,
                    hpack: "end",
                    connections: [
                        [
                            "draw",
                            (icon) => {
                                icon.visible = Audio.speaker === stream;
                            },
                        ],
                    ],
                }),
            ],
        }),
    });

const SettingsButton = () =>
    Widget.Button({
        cursor: "pointer",
        on_clicked: () => Utils.execAsync("pavucontrol"),
        child: Widget.Icon(icons.settings),
    });

export const AppMixer = () =>
    Menu({
        name: "app-mixer",
        icon: Widget.Icon(icons.audio.mixer),
        title: Widget.Label("App Mixer"),
        settings: SettingsButton(),
        menu_content: [
            Widget.Box({
                vertical: true,
                binds: [["children", Audio, "apps", (a) => a.map(MixerItem)]],
            }),
        ],
    });

export const SinkSelector = () =>
    Menu({
        name: "sink-selector",
        icon: Widget.Icon(icons.audio.type.headset),
        title: Widget.Label("Sink Selector"),
        settings: SettingsButton(),
        menu_content: [
            Widget.Box({
                vertical: true,
                binds: [
                    ["children", Audio, "speakers", (s) => s.map(SinkItem)],
                ],
            }),
        ],
    });
