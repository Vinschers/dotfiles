import icons from "../icons.js";
import { SimpleToggleButton } from "./ToggleButton.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

export default () =>
    SimpleToggleButton({
        icon: Widget.Icon({
            connections: [
                [
                    Audio,
                    (icon) => {
                        icon.icon = Audio.microphone?.is_muted
                            ? icons.audio.mic.muted
                            : icons.audio.mic.unmuted;
                    },
                    "microphone-changed",
                ],
            ],
        }),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Microphone",
        }),
        status: Widget.Label({
            hpack: "start",
            connections: [
                [
                    Audio,
                    (label) => {
                        label.label = !Audio.microphone?.is_muted
                            ? "Enabled"
                            : "Disabled";
                    },
                ],
            ],
        }),
        // @ts-ignore
        toggle: () => (Audio.microphone.is_muted = !Audio.microphone.is_muted),
        connection: [Audio, () => !Audio.microphone?.is_muted],
    });
