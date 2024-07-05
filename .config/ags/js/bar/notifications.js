import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

import NotificationsService from "../../services/notifications.js";
import icons from "../icons.js";

const Notifications = () =>
    Widget.Button({
        class_name: "notifications",
        visible: NotificationsService.bind("count").as(
            (count) => count > 0,
        ),
        on_clicked: () => Utils.execAsync("swaync-client -t -sw"),
        child: Widget.Box({
            spacing: 6,
            children: [
                Widget.Label({
                    label: NotificationsService.bind("count").as(
                        (count) => count.toString(),
                    )
                }),
                Widget.Label({
                    class_name: "notifications-icon",
                    label: NotificationsService.bind("dnd").as(dnd => {
                        if (dnd)
                            return icons.notifications.dnd;
                        return icons.notifications.default;
                    }),
                })
            ]
        }),
    });

export default Notifications;
