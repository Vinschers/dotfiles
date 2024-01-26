import icons from "../icons.js";
import PopupWindow from "../misc/PopupWindow.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

export const opened = Variable("");
App.connect("window-toggled", (_, name, visible) => {
    if (name === "quicksettings" && !visible)
        Utils.timeout(500, () => (opened.value = ""));
});

export const Arrow = (name) =>
    Widget.Button({
        cursor: "pointer",
        class_name: "arrow",
        child: Widget.Icon({
            icon: icons.ui.arrow.right,
        }),
        on_clicked: () => App.toggleWindow(name),
    });

export const ArrowToggleButton = ({
    name,
    icon,
    label,
    status,
    activate,
    deactivate,
    activateOnArrow = true,
    connection: [service, condition],
}) =>
    Widget.Box({
        class_name: "toggle-btn",
        children: [
            Widget.Button({
                class_names: ["toggle", "arrow-toggle"],
                cursor: "pointer",
                child: Widget.Box({
                    hexpand: true,
                    children: [
                        icon,
                        Widget.Box({
                            hpack: "start",
                            vpack: "center",
                            vertical: true,
                            children: [label, status],
                        }),
                    ],
                }),
                on_clicked: () => {
                    if (condition()) {
                        deactivate();
                        if (opened.value === name) opened.value = "";
                    } else {
                        activate();
                    }
                },
            }),
            Arrow(name, activateOnArrow && activate),
        ],
    }).hook(service, (box) => {
        box.toggleClassName("active", condition());
    });

export const SimpleToggleButton = ({
    icon,
    label,
    status,
    toggle,
    connection: [service, condition],
}) =>
    Widget.Box({
        class_name: "toggle-btn",
        children: [
            Widget.Button({
                class_name: "toggle",
                cursor: "pointer",
                child: Widget.Box({
                    hexpand: true,
                    children: [
                        icon,
                        Widget.Box({
                            hpack: "start",
                            vpack: "center",
                            vertical: true,
                            children: [label, status],
                        }),
                    ],
                }),
                on_clicked: () => toggle(),
            }),
        ],
    }).hook(service, (box) => {
        box.toggleClassName("active", condition());
    });

export const Menu = ({ name, icon, title, settings, menu_content }) =>
    PopupWindow({
        name: name,
        layout: "center",
        hexpand: true,
        vexpand: true,
        content: Widget.Box({
            class_names: ["menu", name],
            vertical: true,
            children: [
                Widget.Box({
                    class_name: "horizontal",
                    children: [
                        Widget.Box({
                            class_name: "title",
                            children: [icon, title],
                        }),
                        Widget.Box({ hexpand: true }),
                        settings,
                    ],
                }),
                Widget.Box({
                    class_name: "content",
                    children: menu_content,
                }),
            ],
        }),
    });
