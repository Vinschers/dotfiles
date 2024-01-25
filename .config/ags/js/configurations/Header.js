import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import HoverableButton from "../misc/HoverableButton.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

export default () => {
    const prettyUptime = (str) => {
        if (str.length >= 4) return str;

        if (str.length === 1) return "0:0" + str;

        if (str.length === 2) return "0:" + str;
    };
    const uptime = Variable(0, {
        poll: [
            60_000,
            "uptime",
            (line) => prettyUptime(line.split(/\s+/)[2].replace(",", "")),
        ],
    });

    return Widget.Box({
        class_name: "controlcenter__header",
        children: [
            Widget.Box({
                children: [
                    Widget.Label({
                        class_name: "controlcenter__uptime",
                        binds: [
                            ["label", uptime, "value", (t) => `uptime ${t}`],
                        ],
                    }),
                ],
            }),
            Widget.Box({
                hexpand: true,
            }),
            HoverableButton({
                class_name: "controlcenter__theme",
                onPrimaryClickRelease: () =>
                    Utils.execAsync(
                        `bash -c ${App.configDir}/bin/randomWallpaper`,
                    ),
                child: Widget.Icon({
                    icon: "applications-graphics-symbolic",
                    size: 16,
                }),
            }),
            HoverableButton({
                class_name: "controlcenter__power",
                onPrimaryClickRelease: () => {},
                child: Widget.Icon({ icon: "system-shutdown", size: 16 }),
            }),
        ],
    });
};
