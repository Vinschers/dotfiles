import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Gtk30 from "gi://Gtk?version=3.0";
import icons from "../icons.js";

const Theme = () =>
    Widget.Box({
        class_name: "theme",
        vertical: true,
        valign: Gtk30.Align.CENTER,
        spacing: 6,
        children: [
            Widget.Button({
                child: Widget.Icon(icons.theme),
            }),
            Widget.Button({
                child: Widget.Icon(icons.wallpaper),
            }),
        ],
    });

export default Theme;
