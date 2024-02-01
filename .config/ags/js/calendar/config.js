import Widget from "resource:///com/github/Aylur/ags/widget.js";

export default () =>
    Widget.Window({
        name: "calendar",
        anchor: ["top", "right"],
        popup: true,
        visible: false,
        layer: "overlay",
        child: Widget.Box({
            class_name: "calendar",
            child: Widget.Calendar({
                hexpand: true,
                hpack: "center",
            }),
        }),
    });
