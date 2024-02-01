import icons from "../icons.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Popup from "../notification/Popup.js";

const ClearButton = () =>
    Widget.Button({
        cursor: "pointer",
        hpack: "end",
        class_name: "notifications__clear-button",
        on_clicked: () => Notifications.clear(),
        child: Widget.Box({
            children: [Widget.Label("Clear all")],
        }),
    }).bind("sensitive", Notifications, "notifications", (n) => n.length > 0);

const NotificationList = () =>
    Widget.Box({
        vertical: true,
        vexpand: true,
    }).hook(Notifications, (box) => {
        box.children = Notifications.notifications.reverse().map(Popup);
        box.visible = Notifications.notifications.length > 0;
    });

const Placeholder = () =>
    Widget.Box({
        class_name: "placeholder",
        vertical: true,
        vpack: "center",
        hpack: "center",
        vexpand: true,
        hexpand: true,
        children: [
            Widget.Icon(icons.notifications.silent),
            Widget.Label("Your inbox is empty"),
        ],
    }).bind("visible", Notifications, "notifications", (n) => n.length === 0);

export default () =>
    Widget.Box({
        class_name: "notifications",
        vertical: true,
        children: [
            Widget.Scrollable({
                class_name: "notification-scrollable",
                hscroll: "never",
                vscroll: "automatic",
                child: Widget.Box({
                    class_name: "notification-list",
                    vertical: true,
                    children: [NotificationList(), Placeholder()],
                }),
            }),
            ClearButton(),
        ],
    });
