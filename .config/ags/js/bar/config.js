import Widget from "resource:///com/github/Aylur/ags/widget.js";

import Workspaces from "./workspaces.js";
import Clock from "./clock.js";
import Media from "./media.js";
import Battery from "./battery.js";
import SysTray from "./systray.js";
import Configurations from "./configurations.js";
import System from "./system.js";
import Keyboard from "./keyboard.js";
import Theme from "./theme.js";
import Weather from "./weather.js";
import Packages from "./packages.js";

/**
 * @param {number} monitor
 */
const Left = (monitor) =>
    Widget.Box({
        children: [Workspaces(monitor), Media()],
    });

const Center = () =>
    Widget.Box({
        children: [Clock()],
    });

const Right = () =>
    Widget.Box({
        hpack: "end",
        spacing: 12,
        children: [
            Packages(),
            Weather(),
            Theme(),
            Keyboard(),
            System(),
            Configurations(),
            Battery(),
            SysTray(),
        ],
    });

/**
 * @param {number} monitor
 */
export default (monitor) =>
    Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(monitor),
            center_widget: Center(),
            end_widget: Right(),
        }),
    });
