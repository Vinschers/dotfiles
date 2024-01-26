import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import icons from "../icons.js";

export default () => {
    const prettyUptime = (str) => {
        if (str.length >= 4) {
            return str
                .split(":")
                .map((s) => s.padStart(2, "0"))
                .join(":");
        }

        if (str.length === 1) return "00:0" + str;

        if (str.length === 2) return "00:" + str;
    };
    const uptime = Variable(0, {
        poll: [
            60_000,
            "uptime",
            (line) => prettyUptime(line.split(/\s+/)[2].replace(",", "")),
        ],
    });

    return Widget.Box({
        class_name: "footer",
        children: [
            Widget.Box({
                class_name: "footer-item",
                children: [
                    Widget.Label({
                        class_name: "uptime",
                        binds: [
                            ["label", uptime, "value", (t) => `uptime ${t}`],
                        ],
                    }),
                ],
            }),
            Widget.Box({
                hexpand: true,
            }),

            Widget.Button({
                class_names: ["footer-item", "wallpaper"],
                cursor: "pointer",
                on_primary_click: () =>
                    Utils.execAsync(
                        'sh -c "$HOME/.local/share/wallpapers/update.sh"',
                    ).catch(console.error),
                on_secondary_click: () =>
                    Utils.execAsync(
                        'sh -c "$HOME/.local/share/wallpapers/update.sh -1"',
                    ).catch(console.error),
                child: Widget.Icon(icons.footer.wallpaper),
            }),
            Widget.Button({
                class_names: ["footer-item", "theme"],
                cursor: "pointer",
                on_primary_click_release: () =>
                    Utils.execAsync(
                        `notify-send "TODO"`,
                    ),
                child: Widget.Icon(icons.footer.theme),
            }),
            Widget.Button({
                class_names: ["footer-item", "power"],
                cursor: "pointer",
                on_primary_click_release: () => {},
                child: Widget.Icon(icons.footer.power),
            }),
        ],
    });
};
