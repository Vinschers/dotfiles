import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

import Workspaces from "./workspaces.js";
import ClientTitle from "./client_title.js";
import Clock from "./clock.js";
import Notification from "./notification.js";
import Media from "./media.js";
import Volume from "./volume.js";
import BatteryLabel from "./battery.js";
import SysTray from "./systray.js";

// layout of the bar
const Left = () =>
    Widget.Box({
        children: [Workspaces(), ClientTitle()],
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

const Bar = (monitor = 0) =>
    Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        child: Widget.CenterBox({
            start_widget: Left(),
            center_widget: Center(),
            end_widget: Right(),
        }),
    });

// exporting the config so ags can manage the windows
// export default {
//     style: App.configDir + "/style.css",
//     windows: [
//         Bar(),
//
//         // you can call it, for each monitor
//         // Bar({ monitor: 0 }),
//         // Bar({ monitor: 1 })
//     ],
// };

export default Bar;
