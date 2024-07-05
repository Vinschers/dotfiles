import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Padding from "../misc/Padding.js";
import GraphWidget from "../misc/Graph.js";

import { cpu, temp, ram, gpu } from "../variables.js";

const WIDTH = 300;
const HEIGHT = 120;
const HISTORY_COUNT = 60;

const system = Widget.Box({
    class_name: "system-graphs",
    vertical: true,
    spacing: 12,
    children: [
        Widget.Box({
            spacing: 12,
            children: [
                GraphWidget(WIDTH, HEIGHT, cpu, HISTORY_COUNT, "cpu", "CPU"),
                GraphWidget(WIDTH, HEIGHT, ram, HISTORY_COUNT, "ram", "RAM")
            ],
        }),
        Widget.Box({
            spacing: 12,
            children: [
                GraphWidget(WIDTH, HEIGHT, gpu, HISTORY_COUNT, "gpu", "GPU"),
                GraphWidget(WIDTH, HEIGHT, temp, HISTORY_COUNT, "temp", "Temperature")
            ],
        }),
    ],
});

export default () =>
    Widget.Window({
        name: "system",
        anchor: ["top", "right"],
        visible: false,
        keymode: "exclusive",
        child: Widget.CenterBox({
            start_widget: Padding("system"),
            center_widget: Widget.Box({
                vertical: true,
                children: [system, Padding("system")],
            }),
            end_widget: Padding("system"),
        }),
        setup: (self) => {
            self.keybind("Escape", () => App.closeWindow("system"));
        },
    });
