import Widget from "resource:///com/github/Aylur/ags/widget.js";

import PopupWindow from "../misc/PopupWindow.js";
// import NotificationsColumn from './NotificationsColumn.js';
import Microphone from "./Microphone.js";
import DND from "./DND.js";
import Brightness from "./Brightness.js";
import Header from "./Header.js";

import { Volume } from "./Volume.js";
import { NetworkToggle } from "./Network.js";
import { BluetoothToggle } from "./Bluetooth.js";

const Row = (...widgets) =>
    Widget.Box({
        class_name: "row",
        spacing: 12,
        children: [
            ...widgets,
        ],
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
                        Row(Microphone(), DND()),
                        // Row([
                        //     Widget.Box({
                        //         class_name: "slider-box",
                        //         vertical: true,
                        //         children: [
                        //             Row([Volume()]),
                        //             Row([Brightness()]),
                        //         ],
                        //     }),
                        // ]),
                        Widget.Box({
                            vexpand: true,
                        }),
                        // Header(),
                    ],
                }),
                // NotificationsColumn(),
            ],
        }),
    });
