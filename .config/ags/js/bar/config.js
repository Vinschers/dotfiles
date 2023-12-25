import Widget from "resource:///com/github/Aylur/ags/widget.js";

import Battery from "./battery.js";
import Clock from "./clock.js";
import Configurations from "./configurations.js";
import Keyboard from "./keyboard.js";
import Media from "./media.js";
import Packages from "./packages.js";
import System from "./system.js";
import SysTray from "./systray.js";
import Theme from "./theme.js";
import Title from "./title.js";
import Weather from "./weather.js";
import Workspaces from "./workspaces.js";

/**
 * @param {number} monitor
 */
const Left = (monitor) =>
    Widget.Box({
        class_name: "bar-left",
        hpack: "start",
        children: [Media()],
    });

const Center = (monitor) =>
    Widget.Box({
        hpack: "center",
        class_name: "bar-center",
        children: [Workspaces(monitor)],
    });

const Right = (monitor) =>
    Widget.Box({
        class_name: "bar-right",
        hpack: "end",
        spacing: 16,
        children: [
            Packages(),
            Weather(),
            Theme(),
            Keyboard(),
            System(),
            Configurations(),
            Battery(),
            Clock(),
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
            center_widget: Center(monitor),
            end_widget: Right(monitor),
        }),
    });
