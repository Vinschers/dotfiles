import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Padding from "../misc/Padding.js";

import Microphone from "./Microphone.js";
import Brightness from "./Brightness.js";
import NightLight from "./NightLight.js";
import Footer from "./Footer.js";

import { VolMicrophone, Volume } from "./Volume.js";
import { NetworkToggle } from "./Network.js";
import { BluetoothToggle } from "./Bluetooth.js";

const Row = (...widgets) =>
    Widget.Box({
        class_name: "row",
        spacing: 12,
        children: [...widgets],
    });

const configurations = Widget.Box({
    class_name: "configurations-window",
    children: [
        Widget.Box({
            class_name: "configurations-main",
            vertical: true,
            spacing: 16,
            children: [
                Row(NetworkToggle(), BluetoothToggle()),
                Row(NightLight(), Microphone()),
                Widget.Box(),
                Row(
                    Widget.Box({
                        class_name: "slider-box",
                        vertical: true,
                        spacing: 16,
                        children: [
                            Row(Volume()),
                            Row(VolMicrophone()),
                            Row(Brightness()),
                        ],
                    }),
                ),
                Widget.Box({
                    vexpand: true,
                }),
                Footer(),
            ],
        }),
    ],
});

export default () =>
    Widget.Window({
        name: "configurations",
        anchor: ["top", "right"],
        visible: false,
        keymode: "exclusive",
        child: Widget.CenterBox({
            start_widget: Padding("configurations"),
            center_widget: Widget.Box({
                vertical: true,
                children: [configurations, Padding("configurations")],
            }),
            end_widget: Padding("configurations"),
        }),
        setup: (self) => {
            self.keybind("Escape", () => App.closeWindow("configurations"));
        },
    });
