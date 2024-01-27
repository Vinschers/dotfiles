import Widget from "resource:///com/github/Aylur/ags/widget.js";

import PopupWindow from "../misc/PopupWindow.js";
import NotificationsColumn from './NotificationsColumn.js';
import Microphone from "./Microphone.js";
import DND from "./DND.js";
import Brightness from "./Brightness.js";
import NightLight from "./NightLight.js";
import Record from "./Record.js";
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

export default () =>
    PopupWindow({
        name: "configurations",
        anchor: ["top", "right"],
        layout: "top",
        content: Widget.Box({
            class_name: "configurations-window",
            children: [
                Widget.Box({
                    class_name: "configurations-main",
                    vertical: true,
                    spacing: 16,
                    children: [
                        Row(NetworkToggle(), BluetoothToggle()),
                        Row(NightLight(), DND()),
                        Row(Microphone(), Record()),
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
                NotificationsColumn(),
            ],
        }),
    });
