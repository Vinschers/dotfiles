const { Gdk, Gtk } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
const { execAsync, exec } = Utils;
import { setupCursorHoverGrab } from "../misc/cursorhover.js";
import { dumpToWorkspace, swapWorkspace } from "./actions.js";

const SCREEN_WIDTH = Number(
    exec(
        `sh -c "xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1 | head -1" | awk '{print $1}'`,
    ),
);
const SCREEN_HEIGHT = Number(
    exec(
        `sh -c "xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2 | head -1" | awk '{print $1}'`,
    ),
);

const OVERVIEW_SCALE = 0.18; // = overview workspace box / screen size
const OVERVIEW_WS_NUM_SCALE = 0.09;
const OVERVIEW_WS_NUM_MARGIN_SCALE = 0.07;
const TARGET = [Gtk.TargetEntry.new("text/plain", Gtk.TargetFlags.SAME_APP, 0)];

const overviewTick = Variable(false);

function truncateTitle(str) {
    let lastDash = -1;
    let found = -1; // 0: em dash, 1: en dash, 2: minus, 3: vertical bar, 4: middle dot
    for (let i = str.length - 1; i >= 0; i--) {
        if (str[i] === "—") {
            found = 0;
            lastDash = i;
        } else if (str[i] === "–" && found < 1) {
            found = 1;
            lastDash = i;
        } else if (str[i] === "-" && found < 2) {
            found = 2;
            lastDash = i;
        } else if (str[i] === "|" && found < 3) {
            found = 3;
            lastDash = i;
        } else if (str[i] === "·" && found < 4) {
            found = 4;
            lastDash = i;
        }
    }
    if (lastDash === -1) return str;
    return str.substring(0, lastDash);
}

function iconExists(iconName) {
    let iconTheme = Gtk.IconTheme.get_default();
    return iconTheme.has_icon(iconName);
}

function substitute(str) {
    const subs = [
        { from: "code-url-handler", to: "visual-studio-code" },
        { from: "Code", to: "visual-studio-code" },
        { from: "GitHub Desktop", to: "github-desktop" },
        { from: "wpsoffice", to: "wps-office2019-kprometheus" },
        { from: "gnome-tweaks", to: "org.gnome.tweaks" },
        { from: "Minecraft* 1.20.1", to: "minecraft" },
        { from: "", to: "image-missing" },
    ];

    for (const { from, to } of subs) {
        if (from === str) return to;
    }

    if (!iconExists(str)) str = str.toLowerCase().replace(/\s+/g, "-"); // Turn into kebab-case
    return str;
}

const ContextMenuWorkspaceArray = (monitor, { label, actionFunc, thisWorkspace }) =>
    Widget.MenuItem({
        label: `${label}`,
        setup: (menuItem) => {
            let submenu = new Gtk.Menu();
            submenu.class_name = "menu";
            for (let i = 1; i <= 10; i++) {
                let button = new Gtk.MenuItem({
                    label: `Workspace ${i}`,
                });
                button.connect("activate", () => {
                    // execAsync([`${onClickBinary}`, `${thisWorkspace}`, `${i}`]).catch(print);
                    actionFunc(thisWorkspace, Number(`${monitor}${i}`));
                });
                submenu.append(button);
            }
            menuItem.set_reserve_indicator(true);
            menuItem.set_submenu(submenu);
        },
    });

const client = ({
    address,
    monitor,
    size: [w, h],
    workspace: { id, name },
    class: c,
    title,
    xwayland,
}) => {
    const revealInfoCondition = Math.min(w, h) * OVERVIEW_SCALE > 70;
    if (w <= 0 || h <= 0) return null;
    // title = truncateTitle(title);
    return Widget.Button({
        class_name: "overview-tasks-window",
        hpack: "center",
        vpack: "center",
        on_clicked: () => {
            Hyprland.sendMessage(`dispatch focuswindow address:${address}`);
            App.closeWindow(`overview${monitor}`);
        },
        on_middle_click_release: () =>
            Hyprland.sendMessage(`dispatch closewindow address:${address}`),
        on_secondary_click: (button) => {
            button.toggleClassName("overview-tasks-window-selected", true);
            const menu = Widget.Menu({
                class_name: "menu",
                children: [
                    Widget.MenuItem({
                        child: Widget.Label({
                            xalign: 0,
                            label: "Close (Middle-click)",
                        }),
                        on_activate: () =>
                            Hyprland.sendMessage(
                                `dispatch closewindow address:${address}`,
                            ),
                    }),
                    ContextMenuWorkspaceArray(monitor, {
                        label: "Dump windows to workspace",
                        actionFunc: dumpToWorkspace,
                        thisWorkspace: Number(id),
                    }),
                    ContextMenuWorkspaceArray(monitor, {
                        label: "Swap windows with workspace",
                        actionFunc: swapWorkspace,
                        thisWorkspace: Number(id),
                    }),
                ],
            });
            menu.connect("deactivate", () => {
                button.toggleClassName("overview-tasks-window-selected", false);
            });
            menu.connect("selection-done", () => {
                button.toggleClassName("overview-tasks-window-selected", false);
            });
            menu.popup_at_pointer(null); // Show the menu at the pointer's position
        },
        child: Widget.Box({
            css: `
                min-width: ${Math.max(w * OVERVIEW_SCALE - 4, 1)}px;
                min-height: ${Math.max(h * OVERVIEW_SCALE - 4, 1)}px;
            `,
            homogeneous: true,
            child: Widget.Box({
                vertical: true,
                vpack: "center",
                children: [
                    Widget.Icon({
                        icon: substitute(c),
                        size: (Math.min(w, h) * OVERVIEW_SCALE) / 2.5,
                    }),
                    // TODO: Add xwayland tag instead of just having italics
                    Widget.Revealer({
                        transition: "slide_down",
                        reveal_child: revealInfoCondition,
                        child: Widget.Label({
                            truncate: "end",
                            class_name: `${
                                xwayland ? "xwayland" : ""
                            }`,
                            css: `
                                font-size: ${
                                    (Math.min(SCREEN_WIDTH, SCREEN_HEIGHT) *
                                        OVERVIEW_SCALE) /
                                    14.6
                                }px;
                                margin: 0px ${
                                    (Math.min(SCREEN_WIDTH, SCREEN_HEIGHT) *
                                        OVERVIEW_SCALE) /
                                    10
                                }px;
                            `,
                            // If the title is too short, include the class
                            label: title.length <= 1 ? `${c}: ${title}` : title,
                        }),
                    }),
                ],
            }),
        }),
        tooltip_text: `${c}: ${title}`,
        setup: (button) => {
            setupCursorHoverGrab(button);

            button.drag_source_set(
                Gdk.ModifierType.BUTTON1_MASK,
                TARGET,
                Gdk.DragAction.MOVE,
            );
            button.drag_source_set_icon_name(substitute(c));
            // button.drag_source_set_icon_gicon(icon);

            button.connect("drag-begin", (button) => {
                // On drag start, add the dragging class
                button.toggleClassName("overview-tasks-window-dragging", true);
            });
            button.connect("drag-data-get", (_w, _c, data) => {
                // On drag finish, give address
                data.set_text(address, address.length);
                button.toggleClassName("overview-tasks-window-dragging", false);
            });
        },
    });
};

const workspace = (monitor, index) => {
    const fixed = Gtk.Fixed.new();
    const WorkspaceNumber = (index) =>
        Widget.Label({
            class_name: "overview-tasks-workspace-number",
            label: `${index}`,
            css: `
            margin: ${
                Math.min(SCREEN_WIDTH, SCREEN_HEIGHT) *
                OVERVIEW_SCALE *
                OVERVIEW_WS_NUM_MARGIN_SCALE
            }px;
            font-size: ${
                SCREEN_HEIGHT * OVERVIEW_SCALE * OVERVIEW_WS_NUM_SCALE
            }px;
        `,
        });
    const widget = Widget.Box({
        class_name: "overview-tasks-workspace",
        vpack: "center",
        css: `
        min-width: ${SCREEN_WIDTH * OVERVIEW_SCALE}px;
        min-height: ${SCREEN_HEIGHT * OVERVIEW_SCALE}px;
        `,
        children: [
            Widget.EventBox({
                hexpand: true,
                vexpand: true,
                on_primary_click: () => {
                    Hyprland.sendMessage(`dispatch workspace ${monitor}${index}`);
                    App.closeWindow(`overview${monitor}`);
                },
                setup: (eventbox) => {
                    eventbox.drag_dest_set(
                        Gtk.DestDefaults.ALL,
                        TARGET,
                        Gdk.DragAction.COPY,
                    );
                    eventbox.connect(
                        "drag-data-received",
                        (_w, _c, _x, _y, data) => {
                            Hyprland.sendMessage(
                                `dispatch movetoworkspacesilent ${monitor}${index},address:${data.get_text()}`,
                            );
                            overviewTick.setValue(!overviewTick.value);
                        },
                    );
                },
                child: fixed,
            }),
        ],
    });
    widget.update = (clients) => {
        clients = clients.filter(
            ({ workspace: { id } }) => id === Number(`${monitor}${index}`),
        );

        // this is for my monitor layout
        // shifts clients back by SCREEN_WIDTHpx if necessary
        clients = clients.map((client) => {
            const [x, y] = client.at;
            client.at = [x % SCREEN_WIDTH, y % SCREEN_HEIGHT]
            return client;
        });

        const children = fixed.get_children();
        for (let i = 0; i < children.length; i++) {
            const child = children[i];
            child.destroy();
        }
        fixed.put(WorkspaceNumber(index), 0, 0);

        for (let i = 0; i < clients.length; i++) {
            const c = clients[i];
            if (c.mapped) {
                fixed.put(
                    client(c),
                    c.at[0] * OVERVIEW_SCALE,
                    c.at[1] * OVERVIEW_SCALE,
                );
            }
        }

        fixed.show_all();
    };
    return widget;
};

const arr = (s, n) => {
    const array = [];
    for (let i = 0; i < n; i++) array.push(s + i);

    return array;
};

const OverviewRow = (
    monitor,
    { startWorkspace, workspaces, windowName = "overview0" },
) =>
    Widget.Box({
        children: arr(startWorkspace, workspaces).map((index) =>
            workspace(monitor, index),
        ),
        attribute: {
            update: (box) => {
                if (!App.getWindow(windowName).visible) return;
                execAsync("hyprctl -j clients")
                    .then((clients) => {
                        const json = JSON.parse(clients);
                        const children = box.get_children();
                        for (let i = 0; i < children.length; i++) {
                            const ch = children[i];
                            ch.update(json);
                        }
                    })
                    .catch(print);
            },
        },
        setup: (box) =>
            box
                .hook(overviewTick, (box) => box.attribute.update(box))
                // .hook(Hyprland, (box, name, data) => { // idk, does this make it lag occasionally?
                //     console.log(name)
                //     if (["changefloatingmode", "movewindow"].includes(name))
                //         box.attribute.update(box);
                // }, 'event')
                .hook(
                    Hyprland,
                    (box) => box.attribute.update(box),
                    "client-added",
                )
                .hook(
                    Hyprland,
                    (box) => box.attribute.update(box),
                    "client-removed",
                )
                .hook(App, (box, name, visible) => {
                    // Update on open
                    if (name == `overview${monitor}` && visible)
                        box.attribute.update(box);
                }),
    });

export default (monitor) => {
    const overviewRevealer = Widget.Revealer({
        reveal_child: true,
        transition: "slide_down",
        transition_duration: 200,
        child: Widget.Box({
            vertical: true,
            class_name: "overview-tasks",
            children: [
                OverviewRow(monitor, {
                    startWorkspace: 1,
                    workspaces: 5,
                    windowName: `overview${monitor}`,
                }),
                OverviewRow(monitor, {
                    startWorkspace: 6,
                    workspaces: 5,
                    windowName: `overview${monitor}`,
                }),
            ],
        }),
    });

    return overviewRevealer;
};
