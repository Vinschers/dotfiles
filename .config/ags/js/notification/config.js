import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import Popup from "./Popup.js";

const Popups = () => {
    const map = new Map();

    const onDismissed = (box, id, force = false) => {
        if (id == undefined || !map.has(id)) return;

        if (map.get(id).attribute.hovered.value && !force) return;

        if (map.size - 1 === 0) box.get_parent().revealChild = false;

        Utils.timeout(200, () => {
            map.get(id)?.destroy();
            map.delete(id);
        });
    };

    const onNotified = (box, id) => {
        if (id == undefined || Notifications.dnd) return;
        const notification = Notifications.getNotification(id);

        map.delete(id);
        map.set(id, Popup(notification));
        box.children = Array.from(map.values()).reverse();
        Utils.timeout(10, () => {
            box.get_parent().revealChild = true;
        });
    };

    return Widget.Box({
        vertical: true,
    })
        .hook(Notifications, onNotified, "notified")
        .hook(Notifications, onDismissed, "dismissed")
        .hook(Notifications, (box, id) => onDismissed(box, id, true), "closed");
};

const PopupList = ({ transition = "slide_down" } = {}) =>
    Widget.Box({
        class_name: "notifications-popup-list",
        child: Widget.Revealer({
            transition,
            child: Popups(),
        }),
    });

export default (monitor) =>
    Widget.Window({
        monitor,
        layer: "overlay",
        name: `notifications${monitor}`,
        anchor: ["top"],
        child: PopupList(),
    });
