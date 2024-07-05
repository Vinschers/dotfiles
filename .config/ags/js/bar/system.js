import Widget from "resource:///com/github/Aylur/ags/widget.js";

import icons from "../icons.js";
import { cpu, temp, ram, gpu, disk } from "../variables.js";

const SystemStatus = (variable, class_name) =>
    Widget.Overlay({
        class_name: class_name,
        pass_through: true,
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

const SystemHardware = () =>
    Widget.Button({
        on_clicked: () => App.toggleWindow("system"),
        class_name: "system",
        vpack: "center",
        child: Widget.Box({
            vertical: true,
            vpack: "center",
            spacing: 2,
            children: [
                SystemStatus(cpu, "cpu"),
                SystemStatus(temp, "temp"),
                SystemStatus(ram, "ram"),
                SystemStatus(gpu, "gpu"),
            ],
        }),
    });

const DiskUsage = () =>
    Widget.CircularProgress({
        class_name: "disk",
        rounded: false,
        inverted: false,
        startAt: 0.75,
        value: disk.bind().as(value => Number(value) / 100),
        child: Widget.Icon({
            class_name: "disk-icon",
            icon: icons.disk,
        }),
    })

const System = () => Widget.Box({
    spacing: 12,
    children: [DiskUsage(), SystemHardware()],
});

export default System;
