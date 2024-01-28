import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

const SidebarModule = ({ name, child }) => {
    return Widget.Box({
        class_name: "sidebar-module",
        vertical: true,
        children: [
            Widget.Button({
                child: Widget.Box({
                    children: [
                        Widget.Label({
                            class_name: "txt-small txt",
                            label: `${name}`,
                        }),
                        Widget.Box({
                            hexpand: true,
                        }),
                        Widget.Label({
                            class_name: "sidebar-module-btn-arrow",
                        }),
                    ],
                }),
            }),
        ],
    });
};

export const QuickScripts = () =>
    SidebarModule({
        name: "Quick scripts",
        child: Widget.Box({}),
    });
