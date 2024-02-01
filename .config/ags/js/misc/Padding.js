import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const Padding = (windowName) =>
    Widget.EventBox({
        hexpand: true,
        vexpand: true,
    }).on("button-press-event", () => App.toggleWindow(windowName));

export default Padding;
