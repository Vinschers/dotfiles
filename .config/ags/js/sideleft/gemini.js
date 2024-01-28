const { Gtk } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

import Gemini from "../../services/gemini.js";
import { setupCursorHover, setupCursorHoverInfo } from "./cursorhover.js";
import { SystemMessage, ChatMessage } from "./ai_chatmessage.js";
import { markdownTest } from "./md2pango.js";
import icons from "../icons.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
const MODEL_NAME = `Gemini`;

export const geminiTabIcon = Widget.Label({
    hpack: "center",
    class_name: "sidebar-chat-apiswitcher-icon",
    label: icons.sideleft.gemini,
});

const GeminiInfo = () => {
    const geminiLogo = Widget.Label({
        hpack: "center",
        class_name: "sidebar-chat-welcome-logo",
        label: icons.sideleft.gemini,
    });
    return Widget.Box({
        class_name: "sidebar-chat-info",
        vertical: true,
        children: [
            geminiLogo,
            Widget.Label({
                class_name: "sidebar-chat-welcome-txt",
                wrap: true,
                justify: Gtk.Justification.CENTER,
                label: "Assistant (Gemini Pro)",
            }),
            Widget.Box({
                hpack: "center",
                spacing: 6,
                children: [
                    Widget.Label({
                        wrap: true,
                        justify: Gtk.Justification.CENTER,
                        label: "Powered by Google",
                    }),
                    Widget.Button({
                        child: Widget.Icon(icons.sideleft.info),
                        tooltip_text:
                            "Uses gemini-pro.\nNot affiliated, endorsed, or sponsored by Google.",
                        setup: setupCursorHoverInfo,
                    }),
                ],
            }),
        ],
    });
};

export const GeminiSettings = () => {
    const label = Widget.Label({
        class_name: "temperature-txt",
        label: `Temperature: ${Gemini.temperature}`,
    });

    const init_prompts = Variable(Gemini.assistantPrompt);

    return Widget.Box({
        class_name: "sidebar-chat-settings",
        vertical: true,
        children: [
            Widget.Box({
                vertical: true,
                children: [
                    label,
                    Widget.Slider({
                        draw_value: false,
                        on_change: ({ value }) => {
                            value = value.toFixed(2);
                            Gemini.temperature = value;
                            label.label = `Temperature: ${value}`;
                        },
                    }).bind("value", Gemini, "temperature"),
                ],
            }),
            Widget.Box({
                hpack: "center",
                children: [
                    Widget.Button({
                        class_name: "sidebar-chat-settings-toggle",
                        tooltip_text: "Tells Gemini:\n- It's a Linux sidebar assistant\n- Be brief and use bullet points",
                        child: Widget.Box({
                            spacing: 6,
                            children: [
                                Widget.Icon({
                                    setup: (self) =>
                                        self.hook(init_prompts, () => {
                                            self.icon = init_prompts.value
                                                ? icons.checked
                                                : icons.check;
                                        }),
                                }),
                                Widget.Label("Enhancements"),
                            ],
                        }),
                        on_clicked: () => {
                            init_prompts.value = !init_prompts.value;
                            Gemini.assistantPrompt = init_prompts.value;
                        },
                        setup: (self) =>
                            self.hook(init_prompts, () => {
                                self.toggleClassName(
                                    "sidebar-chat-settings-toggle-active",
                                    init_prompts.value,
                                );
                            }),
                    }),
                ],
            }),
        ],
        setup: (self) =>
            self
                .hook(
                    Gemini,
                    (self) =>
                        Utils.timeout(200, () => {
                            self.hide();
                        }),
                    "newMsg",
                )
                .hook(
                    Gemini,
                    (self) =>
                        Utils.timeout(200, () => {
                            self.show();
                        }),
                    "clear",
                ),
    });
};

export const GoogleAiInstructions = () =>
    Widget.Box({
        children: [
            Widget.Revealer({
                transition: "slide_down",
                transition_duration: 150,
                setup: (self) =>
                    self.hook(
                        Gemini,
                        (self, hasKey) => {
                            self.reveal_child = Gemini.key.length == 0;
                        },
                        "hasKey",
                    ),
                child: Widget.Button({
                    child: Widget.Label({
                        use_markup: true,
                        wrap: true,
                        class_name: "txt sidebar-chat-welcome-txt",
                        justify: Gtk.Justification.CENTER,
                        label: "A Google AI API key is required\nYou can grab one <u>here</u>, then enter it below",
                    }),
                    setup: setupCursorHover,
                    on_clicked: () => {
                        Utils.execAsync([
                            "sh",
                            "-c",
                            `xdg-open https://makersuite.google.com/app/apikey &`,
                        ]);
                    },
                }),
            }),
        ],
    });

const geminiWelcome = Widget.Box({
    vexpand: true,
    child: Widget.Box({
        vpack: "center",
        hpack: "center",
        hexpand: true,
        vertical: true,
        children: [GeminiInfo(), GoogleAiInstructions(), GeminiSettings()],
    }),
});

export const chatContent = Widget.Box({
    vertical: true,
    setup: (self) =>
        self.hook(
            Gemini,
            (box, id) => {
                const message = Gemini.messages[id];
                if (!message) return;
                box.add(ChatMessage(message, MODEL_NAME));
            },
            "newMsg",
        ),
});

const clearChat = () => {
    Gemini.clear();
    const children = chatContent.get_children();
    for (let i = 0; i < children.length; i++) {
        const child = children[i];
        child.destroy();
    }
};

export const geminiView = Widget.Scrollable({
    class_name: "sidebar-chat-viewport",
    vexpand: true,
    child: Widget.Box({
        vertical: true,
        children: [geminiWelcome, chatContent],
    }),
    setup: (scrolledWindow) => {
        // Show scrollbar
        scrolledWindow.set_policy(
            Gtk.PolicyType.NEVER,
            Gtk.PolicyType.AUTOMATIC,
        );
        const vScrollbar = scrolledWindow.get_vscrollbar();
        vScrollbar.get_style_context().add_class("sidebar-scrollbar");
        // Avoid click-to-scroll-widget-to-view behavior
        Utils.timeout(1, () => {
            const viewport = scrolledWindow.child;
            viewport.set_focus_vadjustment(new Gtk.Adjustment(undefined));
        });
        // Always scroll to bottom with new content
        const adjustment = scrolledWindow.get_vadjustment();
        adjustment.connect("changed", () => {
            adjustment.set_value(
                adjustment.get_upper() - adjustment.get_page_size(),
            );
        });
    },
});

const CommandButton = (command) =>
    Widget.Button({
        class_name: "sidebar-chat-chip",
        on_clicked: () => sendMessage(command),
        setup: setupCursorHover,
        label: command,
    });

export const geminiCommands = Widget.Box({
    spacing: 6,
    class_name: "commands",
    children: [
        Widget.Box({ hexpand: true }),
        CommandButton("/key"),
        CommandButton("/model"),
        CommandButton("/clear"),
    ],
});

export const sendMessage = (text) => {
    // Check if text or API key is empty
    if (text.length == 0) return;
    if (Gemini.key.length == 0) {
        Gemini.key = text;
        chatContent.add(
            SystemMessage(
                `Key saved to\n\`${Gemini.keyPath}\``,
                "API Key",
                geminiView,
            ),
        );
        text = "";
        return;
    }
    // Commands
    if (text.startsWith("/")) {
        if (text.startsWith("/clear")) clearChat();
        else if (text.startsWith("/model"))
            chatContent.add(
                SystemMessage(
                    `Currently using \`${Gemini.modelName}\``,
                    "/model",
                    geminiView,
                ),
            );
        else if (text.startsWith("/prompt")) {
            const firstSpaceIndex = text.indexOf(" ");
            const prompt = text.slice(firstSpaceIndex + 1);
            if (firstSpaceIndex == -1 || prompt.length < 1) {
                chatContent.add(
                    SystemMessage(
                        `Usage: \`/prompt MESSAGE\``,
                        "/prompt",
                        geminiView,
                    ),
                );
            } else {
                Gemini.addMessage("user", prompt);
            }
        } else if (text.startsWith("/key")) {
            const parts = text.split(" ");
            if (parts.length == 1)
                chatContent.add(
                    SystemMessage(
                        `Key stored in:\n\`${Gemini.keyPath}\`\nTo update this key, type \`/key YOUR_API_KEY\``,
                        "/key",
                        geminiView,
                    ),
                );
            else {
                Gemini.key = parts[1];
                chatContent.add(
                    SystemMessage(
                        `Updated API Key at\n\`${Gemini.keyPath}\``,
                        "/key",
                        geminiView,
                    ),
                );
            }
        } else if (text.startsWith("/test"))
            chatContent.add(
                SystemMessage(markdownTest, `Markdown test`, geminiView),
            );
        else
            chatContent.add(
                SystemMessage(`Invalid command.`, "Error", geminiView),
            );
    } else {
        Gemini.send(text);
    }
};
