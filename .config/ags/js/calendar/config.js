import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Padding from "../misc/Padding.js";

const calendar = Widget.Box({
    class_name: "calendar",
    child: Widget.Calendar({
        hexpand: true,
        hpack: "center",
        showDayNames: true,
        showDetails: true,
        showHeading: true,
    }),
});

export default () =>
    Widget.Window({
        name: "calendar",
        anchor: ["top", "right"],
        visible: false,
        keymode: "exclusive",
        child: Widget.CenterBox({
            start_widget: Padding("calendar"),
            center_widget: Widget.Box({
                vertical: true,
                children: [calendar, Padding("calendar")],
            }),
            end_widget: Padding("calendar"),
        }),
        setup: (self) => {
            self.keybind("Escape", () => App.closeWindow("calendar"));
        },
    });
