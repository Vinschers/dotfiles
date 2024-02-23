import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { SearchAndWindows } from "./windowcontent.js";

export default (monitor) =>
    Widget.Window({
        name: `overview${monitor}`,
        monitor,
        exclusivity: "ignore",
        keymode: "on-demand",
        visible: false,
        anchor: ["top"],
        layer: "overlay",
        child: Widget.Box({
            class_name: "overview-window",
            vertical: true,
            children: [SearchAndWindows(monitor)],
        }),
        setup: (self) => {
            self.keybind("Escape", () => App.closeWindow(`overview${monitor}`));
        },
    });
