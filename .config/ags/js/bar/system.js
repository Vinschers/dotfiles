import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { cpu, temp, ram, gpu } from "../variables.js";

const SystemStatus = (variable, class_name) =>
    Widget.Overlay({
        class_name: class_name,
        child: Widget.ProgressBar({
            class_name: "progress-bar",
            value: variable.bind().transform((value) => Number(value) / 100),
        }),
        overlays: [
            Widget.Box({
                class_name: "progress-wrapper",
            }),
        ],
    });

const System = () =>
    Widget.Button({
        class_name: "system",
        vpack: "center",
        child: Widget.Box({
            vertical: true,
            vpack: "center",
            spacing: 4,
            children: [
                SystemStatus(cpu, "cpu"),
                // SystemStatus(temp, "temp"),
                SystemStatus(ram, "ram"),
                SystemStatus(gpu, "gpu"),
            ],
        }),
    });

export default System;
