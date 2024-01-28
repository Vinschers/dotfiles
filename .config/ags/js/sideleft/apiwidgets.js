import Widget from "resource:///com/github/Aylur/ags/widget.js";

import { setupCursorHover, setupCursorHoverInfo } from "./cursorhover.js";
import {
    geminiView,
    geminiCommands,
    sendMessage as geminiSendMessage,
    geminiTabIcon,
} from "./gemini.js";
import Gemini from "../../services/gemini.js";
import icons from "../icons.js";

const APIS = [
    {
        name: "Assistant (Gemini Pro)",
        sendCommand: geminiSendMessage,
        contentWidget: geminiView,
        commandBar: geminiCommands,
        tabIcon: geminiTabIcon,
        placeholderText: "Message Gemini...",
    },
];
let currentApiId = 0;
APIS[currentApiId].tabIcon.toggleClassName(
    "sidebar-chat-apiswitcher-icon-enabled",
    true,
);

export const chatEntry = Widget.Entry({
    class_name: "sidebar-chat-entry",
    hexpand: true,
    setup: (self) =>
        self.hook(
            Gemini,
            (self) => {
                if (APIS[currentApiId].name != "Assistant (Gemini Pro)") return;
                self.placeholder_text =
                    Gemini.key.length > 0
                        ? "Message Gemini..."
                        : "Enter Google AI API Key...";
            },
            "hasKey",
        ),
    on_change: (entry) => {
        chatSendButton.toggleClassName(
            "sidebar-chat-send-available",
            //@ts-ignore
            entry.text.length > 0,
        );
    },
    on_accept: (entry) => {
        APIS[currentApiId].sendCommand(entry.text);
        entry.text = "";
    },
});

const chatSendButton = Widget.Button({
    class_name: "sidebar-chat-send",
    vpack: "center",
    child: Widget.Icon(icons.sideleft.send),
    setup: setupCursorHover,
    on_clicked: (self) => {
        APIS[currentApiId].sendCommand(chatEntry.text);
        chatEntry.text = "";
    },
});

const textboxArea = Widget.Box({
    // Entry area
    class_name: "sidebar-chat-textarea",
    children: [chatEntry, chatSendButton],
});

const apiContentStack = Widget.Stack({
    vexpand: true,
    transition: "slide_left_right",
    items: APIS.map((api) => [api.name, api.contentWidget]),
});

const apiCommandStack = Widget.Stack({
    transition: "slide_up_down",
    items: APIS.map((api) => [api.name, api.commandBar]),
});

function switchToTab(id) {
    APIS[currentApiId].tabIcon.toggleClassName(
        "sidebar-chat-apiswitcher-icon-enabled",
        false,
    );
    APIS[id].tabIcon.toggleClassName(
        "sidebar-chat-apiswitcher-icon-enabled",
        true,
    );
    apiContentStack.shown = APIS[id].name;
    apiCommandStack.shown = APIS[id].name;
    (chatEntry.placeholder_text = APIS[id].placeholderText),
        (currentApiId = id);
}

const apiSwitcher = Widget.CenterBox({
    center_widget: Widget.Box({
        class_name: "sidebar-chat-apiswitcher",
        hpack: "center",
        children: APIS.map((api, id) =>
            Widget.Button({
                child: api.tabIcon,
                tooltip_text: api.name,
                setup: setupCursorHover,
                on_clicked: () => {
                    switchToTab(id);
                },
            }),
        ),
    }),
});

export default Widget.Box({
    class_name: "content",
    attribute: {
        nextTab: () => switchToTab(Math.min(currentApiId + 1, APIS.length - 1)),
        prevTab: () => switchToTab(Math.max(0, currentApiId - 1)),
    },
    vertical: true,
    homogeneous: false,
    children: [apiSwitcher, apiContentStack, apiCommandStack, textboxArea],
});
