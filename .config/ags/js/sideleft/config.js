import Widget from "resource:///com/github/Aylur/ags/widget.js";
import SidebarLeft from "./sideleft.js";

export default () =>
    Widget.Window({
        name: "sideleft",
        anchor: ["left", "top", "bottom"],
        child: SidebarLeft(),
        visible: false,
        keymode: "exclusive",
        layer: "top",
        setup: (self) => {
            self.keybind("Escape", () => App.closeWindow("sideleft"));
        },
    });
