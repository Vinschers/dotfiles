const { Gdk } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import { setupCursorHover } from "./cursorhover.js";
import { NavigationIndicator } from "./navigationindicator.js";
import toolBox from "./toolbox.js";
import apiWidgets from "./apiwidgets.js";
import { chatEntry } from "./apiwidgets.js";
import icons from "../icons.js";

const contents = [
    {
        name: "apis",
        content: apiWidgets,
        icon: icons.sideleft.apis,
        friendlyName: "APIs",
    },
    {
        name: "tools",
        content: toolBox,
        icon: icons.sideleft.toolbox,
        friendlyName: "Tools",
    },
];
let currentTabId = 0;

const contentStack = Widget.Stack({
    vexpand: true,
    transition: "slide_left_right",
    items: contents.map((item) => [item.name, item.content]),
});

function switchToTab(id) {
    const allTabs = navTabs.get_children();
    const tabButton = allTabs[id];
    allTabs[currentTabId].toggleClassName("sidebar-selector-tab-active", false);
    allTabs[id].toggleClassName("sidebar-selector-tab-active", true);
    contentStack.shown = contents[id].name;
    if (tabButton) {
        // Fancy highlighter line width
        const buttonWidth = tabButton.get_allocated_width();
        const highlightWidth = tabButton
            .get_children()[0]
            .get_allocated_width();
        navIndicator.css = `
            font-size: ${id}px; 
            padding: 0px ${(buttonWidth - highlightWidth) / 2}px;
        `;
    }
    currentTabId = id;
}
const SidebarTabButton = (navIndex) =>
    Widget.Button({
        // hexpand: true,
        class_name: "sidebar-selector-tab",
        on_clicked: (self) => {
            switchToTab(navIndex);
        },
        child: Widget.Box({
            hpack: "center",
            children: [
                Widget.Icon(contents[navIndex].icon),
                Widget.Label({
                    label: `${contents[navIndex].friendlyName}`,
                }),
            ],
        }),
        setup: (button) =>
            Utils.timeout(1, () => {
                setupCursorHover(button);
                button.toggleClassName(
                    "sidebar-selector-tab-active",
                    currentTabId == navIndex,
                );
            }),
    });

const navTabs = Widget.Box({
    homogeneous: true,
    children: contents.map((item, id) =>
        SidebarTabButton(id),
    ),
});

const navIndicator = NavigationIndicator(2, false, {
    // The line thing
    class_name: "sidebar-selector-highlight",
    css: "font-size: 0px; padding: 0rem 4.160rem;", // Shushhhh
});

const navBar = Widget.Box({
    class_name: "nav-bar",
    vertical: true,
    hexpand: true,
    children: [navTabs, navIndicator],
});

export default () =>
    Widget.Box({
        // vertical: true,
        vexpand: true,
        hexpand: true,
        css: "min-width: 2px;",
        children: [
            Widget.EventBox({
                on_primary_click: () => App.closeWindow("sideleft"),
                on_secondary_click: () => App.closeWindow("sideleft"),
                on_middle_click: () => App.closeWindow("sideleft"),
            }),
            Widget.Box({
                vertical: true,
                vexpand: true,
                class_name: "sidebar-left",
                children: [
                    Widget.Box({
                        child: navBar,
                    }),
                    contentStack,
                ],
            }),
        ],
        setup: (self) =>
            self.on("key-press-event", (widget, event) => {
                // Handle keybinds
                if (event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK) {
                    // Switch sidebar tab
                    if (event.get_keyval()[1] === Gdk.KEY_Tab)
                        switchToTab((currentTabId + 1) % contents.length);
                    else if (event.get_keyval()[1] === Gdk.KEY_Page_Up)
                        switchToTab(Math.max(currentTabId - 1, 0));
                    else if (event.get_keyval()[1] === Gdk.KEY_Page_Down)
                        switchToTab(
                            Math.min(currentTabId + 1, contents.length - 1),
                        );
                }
                if (contentStack.shown == "apis") {
                    // If api tab is focused
                    // Automatically focus entry when typing
                    if (
                        (!(
                            event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK
                        ) &&
                            event.get_keyval()[1] >= 32 &&
                            event.get_keyval()[1] <= 126 &&
                            widget != chatEntry &&
                            event.get_keyval()[1] != Gdk.KEY_space) ||
                        (event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK &&
                            event.get_keyval()[1] === Gdk.KEY_v)
                    ) {
                        chatEntry.grab_focus();
                        chatEntry.set_text(
                            chatEntry.text +
                                String.fromCharCode(event.get_keyval()[1]),
                        );
                        chatEntry.set_position(-1);
                    }
                    // Switch API type
                    else if (
                        !(
                            event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK
                        ) &&
                        event.get_keyval()[1] === Gdk.KEY_Page_Down
                    ) {
                        const toSwitchTab = contentStack.get_visible_child();
                        toSwitchTab.attribute.nextTab();
                    } else if (
                        !(
                            event.get_state()[1] & Gdk.ModifierType.CONTROL_MASK
                        ) &&
                        event.get_keyval()[1] === Gdk.KEY_Page_Up
                    ) {
                        const toSwitchTab = contentStack.get_visible_child();
                        toSwitchTab.attribute.prevTab();
                    }
                }
            }),
    });
