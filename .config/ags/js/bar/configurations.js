import icons from "../icons.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Audio from "resource:///com/github/Aylur/ags/service/audio.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Brightness from "../services/brightness.js";

const BluetoothIndicator = () =>
    Widget.Icon({
        icon: Bluetooth.bind("enabled").transform((on) =>
            on ? icons.bluetooth.enabled : icons.bluetooth.disabled,
        ),
    });

const WifiIndicator = () =>
    Widget.Box({
        children: [
            Widget.Icon({
                icon: Network.wifi.bind("icon_name"),
            }),
        ],
    });

const WiredIndicator = () =>
    Widget.Icon({
        icon: Network.wired
            .bind("icon_name")
            .transform((v) => v?.toString() || ""),
    });

const NetworkIndicator = () =>
    Widget.Stack({
        items: [
            ["wifi", WifiIndicator()],
            ["wired", WiredIndicator()],
        ],
        shown: Network.bind("primary")
            .transform((p) => p || "wifi")
            .transform((v) => v?.toString() || ""),
    });

const VolumeIndicator = () =>
    Widget.Icon().hook(
        Audio,
        (self) => {
            if (!Audio.speaker) return;

            const vol = Audio.speaker.volume * 100;
            // @ts-ignore
            const icon = [
                [101, icons.audio.volume.overamplified],
                [67, icons.audio.volume.high],
                [34, icons.audio.volume.medium],
                [1, icons.audio.volume.low],
                [0, icons.audio.volume.muted],
            ].find(([threshold]) => Number(threshold) <= vol)[1];

            self.icon = icon.toString();
        },
        "speaker-changed",
    );

const BrightnessIndicator = () =>
    Widget.Icon().hook(Brightness, (self) => {
        let value = Brightness.screen;
        if (!Brightness.screen) value = 0;

        // @ts-ignore
        const icon = [
            [101, icons.brightness.indicator.on],
            [67, icons.brightness.indicator.high],
            [34, icons.brightness.indicator.medium],
            [1, icons.brightness.indicator.low],
            [0, icons.brightness.indicator.off],
        ].find(([threshold]) => Number(threshold) <= value)[1];

        self.icon = icon.toString();
    });

const Configurations = () =>
    Widget.Button({
        class_name: "configurations",
        on_clicked: () => App.toggleWindow('configurations'),
        child: Widget.Box({
            spacing: 6,
            children: [
                BrightnessIndicator(),
                VolumeIndicator(),
                BluetoothIndicator(),
                NetworkIndicator(),
            ],
        }),
    });

export default Configurations;
