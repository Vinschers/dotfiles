import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

// For each monitor, stores the workspace (1 to 10)
let active_workspaces = [];

/**
 * @param {number} monitor
 */
const Workspaces = (monitor) => {
    active_workspaces.push(1);

    return Widget.Box({
        class_name: "workspaces",
        connections: [
            [
                Hyprland.active.workspace,
                (self) => {
                    const arr = Array.from({ length: 10 }, (_, i) => i + 1);
                    const workspace = Hyprland.getWorkspace(
                        Hyprland.active.workspace.id,
                    );
                    const current_monitor = workspace?.monitorID || 0;
                    const active_ws = (workspace?.id || 1) % 10 || 10;

                    active_workspaces[current_monitor] = active_ws;

                    self.children = arr.map((i) =>
                        Widget.Button({
                            on_clicked: () =>
                                execAsync(`hyprctl dispatch workspace ${i}`),
                            child: Widget.Label(`${i}`),
                            class_name:
                                active_workspaces[monitor] == i
                                    ? "focused"
                                    : Hyprland.getWorkspace(Number(`${monitor}${i}`))?.windows || 0 > 0
                                      ? "filled"
                                      : "",
                        }),
                    );
                },
            ],
        ],
    });
};

export default Workspaces;
