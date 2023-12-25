import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import { RoundedCorner } from "../rounded_corner.js";

const NUM_OF_WORKSPACES = 10;

// For each monitor, stores the workspace (1 to 10)
let active_workspaces = [];

function get_active_monitor_ws() {
    const workspace = Hyprland.getWorkspace(Hyprland.active.workspace.id);
    const monitor = workspace?.monitorID || 0;
    const active_ws = (workspace?.id || 1) % 10 || 10;

    return [monitor, active_ws];
}

function on_change_hyprland(monitor, parent_box) {
    const children = parent_box.children;

    children.forEach((child, i) => {
        const ws_before = Hyprland.getWorkspace(Number(`${monitor}${i}`));
        const ws = Hyprland.getWorkspace(Number(`${monitor}${i + 1}`));
        const ws_after = Hyprland.getWorkspace(Number(`${monitor}${i + 2}`));

        //toggleClassName is not part od Gtk.Widget, but we know box.children only includes AgsWidgets

        //@ts-ignore
        child.toggleClassName("occupied", ws?.windows > 0);
        //@ts-ignore
        child.toggleClassName(
            "occupied-left",
            !ws_before || ws_before?.windows <= 0 || i == 0,
        );
        //@ts-ignore
        child.toggleClassName(
            "occupied-right",
            !ws_after || ws_after?.windows <= 0 || i + 1 == NUM_OF_WORKSPACES,
        );
    });
}

function on_change_workspace(monitor, parent_box) {
    const children = parent_box.children;
    const [current_monitor, active_ws] = get_active_monitor_ws();

    active_workspaces[current_monitor] = active_ws;

    children.forEach((child, i) => {
        child.toggleClassName("active", active_workspaces[monitor] == i + 1);
    });
}

/**
 * @param {number} i
 */
const Workspace = (i) =>
    Widget.Button({
        on_primary_click: () => execAsync(`hyprsome workspace ${i}`),
        child: Widget.Label({
            label: `${i}`,
            class_name: "workspace-label",
        }),
        class_name: "workspace",
    });

/**
 * @param {number} monitor
 */
const Workspaces = (monitor) => {
    active_workspaces.push(1);

    return Widget.Box({
        class_name: "workspaces",
        children: [
            RoundedCorner("bottomleft", { class_name: "workspace-corner" }),
            Widget.Box({
                children: Array.from({ length: NUM_OF_WORKSPACES }, (_, i) =>
                    Workspace(i + 1),
                ),
            })
                .hook(
                    Hyprland,
                    (box) => on_change_hyprland(monitor, box),
                    "notify::workspaces",
                )
                .hook(Hyprland.active.workspace, (box) =>
                    on_change_workspace(monitor, box),
                ),
            RoundedCorner("bottomright", { class_name: "workspace-corner" }),
        ],
    });
};

export default Workspaces;
