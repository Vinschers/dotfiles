import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";

import NotificationsService from "../../services/notifications.js";
import icons from "../icons.js";

const Notifications = () =>
    Widget.Button({
        class_name: "notifications",
        visible: NotificationsService.bind("count").transform(
            (count) => count > 0,
        ),
        on_clicked: () => Utils.execAsync("swaync-client -t -sw"),
        child: Widget.Label({
            class_name: "notifications-icon",
            label: icons.notifications
        }),
    });

export default Notifications;
