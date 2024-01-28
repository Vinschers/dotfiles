import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SidebarLeft from "./sideleft.js";

export default () =>
    Widget.Window({
        name: "sideleft",
        anchor: ["left", "top", "bottom"],
        child: SidebarLeft(),
        popup: true,
        visible: false,
        focusable: true,
        layer: 'top'
    });
