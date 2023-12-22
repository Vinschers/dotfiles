import Widget from "resource:///com/github/Aylur/ags/widget.js";

import Workspaces from "./workspaces.js";
import Clock from "./clock.js";
import Notification from "./notification.js";
import Media from "./media.js";
import Volume from "./volume.js";
import BatteryLabel from "./battery.js";
import SysTray from "./systray.js";

const Left = (monitor) =>
    Widget.Box({
        children: [Workspaces(monitor)],
    });

const Center = () =>
    Widget.Box({
        children: [Media(), Notification()],
    });

const Right = () =>
    Widget.Box({
        hpack: "end",
        children: [Volume(), Clock(), SysTray()],
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
