import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Notifications from "resource:///com/github/Aylur/ags/service/notifications.js";
import icons from "../icons.js";
import { SimpleToggleButton } from "./ToggleButton.js";

export default () =>
    SimpleToggleButton({
        icon: Widget.Icon({}).hook(
            Notifications,
            (icon) => {
                icon.icon = Notifications.dnd
                    ? icons.notifications.silent
                    : icons.notifications.noisy;
            },
            "notify::dnd",
        ),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Notifications",
        }),
        status: Widget.Label({
            hpack: "start",
        }).hook(Notifications, (label) => {
            label.label = !Notifications.dnd ? "Enabled" : "Disabled";
        }),
        toggle: () => (Notifications.dnd = !Notifications.dnd),
        connection: [Notifications, () => !Notifications.dnd],
    });
