import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { QuickScripts } from "./quickscripts.js";

export default Widget.Scrollable({
    hscroll: "never",
    vscroll: "automatic",
    child: Widget.Box({
        vertical: true,
        children: [
            QuickScripts(),
        ],
    }),
});
