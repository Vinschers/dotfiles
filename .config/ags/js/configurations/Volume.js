import icons from "../icons.js";
import FontIcon from "../misc/FontIcon.js";
import { Arrow, Menu } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import HoverableButton from "../misc/HoverableButton.js";

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
    HoverableButton({
        class_name: "slider__tooltip",
        on_clicked: () => (Audio[type].is_muted = !Audio[type].is_muted),
        child: Widget.Icon({
            connections: [
                [
                    Audio,
                    (icon) => {
                        if (!Audio[type]) return;

                        icon.icon =
                            type === "speaker"
                                ? getAudioTypeIcon(Audio[type].icon_name || "")
                                : icons.audio.mic.high;

                        icon.tooltip_text = `Volume ${Math.floor(
                            Audio[type].volume * 100,
                        )}%`;
                    },
                    `${type}-changed`,
                ],
            ],
        }),
    });

/** @param {'speaker' | 'microphone'=} type */
const VolumeSlider = (type = "speaker") =>
    Widget.Slider({
        class_name: "volume__slider",
        hexpand: true,
        draw_value: false,
        on_change: ({ value }) => (Audio[type].volume = value),
        connections: [
            [
                Audio,
                (slider) => {
                    slider.value = Audio[type]?.volume || 0;
                },
                `${type}-changed`,
            ],
        ],
    });

export const Volume = () =>
    Widget.Box({
        class_name: "volume__box",
        children: [
            VolumeIndicator("speaker"),
            VolumeSlider("speaker"),
            Widget.Box({
                vpack: "center",
                child: Arrow("sink-selector"),
            }),
            Widget.Box({
                vpack: "center",
                child: Arrow("app-mixer"),
                connections: [
                    [
                        Audio,
                        (box) => {
                            box.visible = Audio.apps.length > 0;
                        },
                    ],
                ],
            }),
        ],
    });

export const Microhone = () =>
    Widget.Box({
        class_name: "slider",
        binds: [["visible", Audio, "recorders", (r) => r.length > 0]],
        children: [VolumeIndicator("microphone"), VolumeSlider("microphone")],
    });

/** @param {import('types/service/audio').Stream} stream */
const MixerItem = (stream) =>
    Widget.Box({
        hexpand: true,
        class_name: "mixer-item horizontal",
        children: [
            Widget.Icon({
                binds: [["tooltipText", stream, "name"]],
                connections: [
                    [
                        stream,
                        (icon) => {
                            icon.icon = Utils.lookUpIcon(stream.name || "")
                                ? stream.name || ""
                                : icons.mpris.fallback;
                        },
                    ],
                ],
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Widget.Label({
                        xalign: 0,
                        truncate: "end",
                        binds: [["label", stream, "description"]],
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
                connections: [
                    [
                        stream,
                        (l) => {
                            l.label = `${Math.floor(stream.volume * 100)}%`;
                        },
                    ],
                ],
            }),
        ],
    });

/** @param {import('types/service/audio').Stream} stream */
const SinkItem = (stream) =>
    HoverableButton({
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
    HoverableButton({
        on_clicked: () => Utils.execAsync("pavucontrol"),
        hexpand: true,
        child: Widget.Box({
            children: [Widget.Icon(icons.settings), Widget.Label("Settings")],
        }),
    });

export const AppMixer = () =>
    Menu({
        name: "app-mixer",
        icon: FontIcon(icons.audio.mixer),
        title: Widget.Label("App Mixer"),
        menu_content: [
            Widget.Box({
                vertical: true,
                binds: [["children", Audio, "apps", (a) => a.map(MixerItem)]],
            }),
            Widget.Separator({}),
            SettingsButton(),
        ],
    });

export const SinkSelector = () =>
    Menu({
        name: "sink-selector",
        icon: Widget.Icon(icons.audio.type.headset),
        title: Widget.Label("Sink Selector"),
        menu_content: [
            Widget.Box({
                vertical: true,
                binds: [
                    ["children", Audio, "speakers", (s) => s.map(SinkItem)],
                ],
            }),
            Widget.Separator({}),
            SettingsButton(),
        ],
    });
