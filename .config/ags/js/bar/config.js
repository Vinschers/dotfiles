import Widget from "resource:///com/github/Aylur/ags/widget.js";

import Battery from "./battery.js";
import Clock from "./clock.js";
import Configurations from "./configurations.js";
import Keyboard from "./keyboard.js";
import Media from "./media.js";
import Packages from "./packages.js";
import System from "./system.js";
import SysTray from "./systray.js";
import Title from "./title.js";
import Weather from "./weather.js";
import Workspaces from "./workspaces.js";
import { RoundedCorner } from "../misc/RoundedCorner.js";

const Left = () =>
    Widget.Box({
        class_name: "bar-left",
        hpack: "start",
        spacing: 16,
        children: [SysTray(), Media()],
    });

/**
 * @param {number} monitor
 */
const Center = (monitor) =>
    Widget.Box({
        hpack: "center",
        class_name: "bar-center",
        children: [
            RoundedCorner("topright", { class_name: "bar-corner" }),
            Workspaces(monitor),
            RoundedCorner("topleft", { class_name: "bar-corner" }),
        ],
    });

const Right = () =>
    Widget.Box({
        class_name: "bar-right",
        hpack: "end",
        spacing: 16,
        children: [
            Packages(),
            Weather(),
            Keyboard(),
            System(),
            Configurations(),
            Battery(),
            Clock(),
        ],
    });

/**
 * @param {number} monitor
 */
export default (monitor) =>
    Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            class_name: "bar",
            start_widget: Left(),
            center_widget: Center(monitor),
            end_widget: Right(),
        }),
    });
