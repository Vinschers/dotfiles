import Widget from "resource:///com/github/Aylur/ags/widget.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";

const SysTray = () =>
    Widget.Box({
        class_name: "systray",
        spacing: 6,
        // @ts-ignore
        children: SystemTray.bind("items").transform((items) => {
            return items.map((item) =>
                Widget.Button({
                    child: Widget.Icon({ binds: [["icon", item, "icon"]] }),
                    on_primary_click: (_, event) => item.activate(event),
                    on_secondary_click: (_, event) => item.openMenu(event),
                    binds: [["tooltip-markup", item, "tooltip-markup"]],
                }),
            );
        }),
    }).bind("visible", SystemTray, "items", (i) => i.length > 0);

export default SysTray;
