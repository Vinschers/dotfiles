import Widget from "resource:///com/github/Aylur/ags/widget.js";
import PopupWindow from "../misc/PopupWindow.js";

export default () =>
    PopupWindow({
        name: "calendar",
        anchor: ["top", "right"],
        layout: "top",
        content: Widget.Box({
            class_name: "calendar",
            child: Widget.Calendar({
                hexpand: true,
                hpack: "center",
            }),
        }),
    });
