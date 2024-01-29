import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { SearchAndWindows } from "./windowcontent.js";

export default (monitor) =>
    Widget.Window({
        name: `overview${monitor}`,
        exclusivity: "ignore",
        focusable: true,
        popup: true,
        visible: false,
        anchor: ["top"],
        layer: "overlay",
        child: Widget.Box({
            vertical: true,
            children: [SearchAndWindows()],
        }),
    });
