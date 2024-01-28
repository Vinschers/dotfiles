const { Gdk, GdkPixbuf, Gio, GLib, Gtk } = imports.gi;
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { Box, Button, Label, Overlay, Revealer, Scrollable, Stack } = Widget;
const { execAsync, exec } = Utils;
import { setupCursorHover, setupCursorHoverInfo } from "../misc/cursorhover.js";
import WaifuService from "../../services/waifus.js";
import icons from "../icons.js";

const IMAGE_REVEAL_DELAY = 13; // Some wait for inits n other weird stuff
const USER_CACHE_DIR = GLib.get_user_cache_dir();

// Create cache folder and clear pics from previous session
Utils.exec(`sh -c 'mkdir -p ${USER_CACHE_DIR}/ags/media/waifus'`);
Utils.exec(`sh -c 'rm ${USER_CACHE_DIR}/ags/media/waifus/*'`);

export function fileExists(filePath) {
    let file = Gio.File.new_for_path(filePath);
    return file.query_exists(null);
}

const CommandButton = (command) =>
    Button({
        class_name: "sidebar-chat-chip sidebar-chat-chip-action",
        on_clicked: () => sendMessage(command),
        setup: setupCursorHover,
        label: command,
    });

export const waifuTabIcon = Box({
    hpack: "center",
    class_name: "sidebar-chat-apiswitcher-icon",
    homogeneous: true,
    children: [Widget.Icon(icons.sideleft.waifus)],
});

const WaifuImage = (taglist) => {
    const ImageState = (icon, name) =>
        Box({
            children: [
                Box({ hexpand: true }),
                Label({
                    class_name: "sidebar-waifu-txt",
                    xalign: 0,
                    label: name,
                }),
                Widget.Icon(icon),
            ],
        });
    const ImageAction = ({ name, icon, action }) =>
        Button({
            class_name: "sidebar-waifu-image-action",
            tooltip_text: name,
            child: Widget.Icon(icon),
            on_clicked: action,
            setup: setupCursorHover,
        });
    const colorIndicator = Box({
        class_name: `sidebar-chat-indicator`,
    });
    const downloadState = Stack({
        homogeneous: false,
        transition: "slide_up_down",
        transition_duration: 150,
        items: [
            ["api", ImageState(icons.sideleft.apis, "Calling API")],
            [
                "download",
                ImageState(icons.sideleft.download, "Downloading image"),
            ],
            ["done", ImageState(icons.sideleft.done, "Finished!")],
            ["error", ImageState(icons.sideleft.error, "Error")],
        ],
    });
    const downloadIndicator = Widget.Revealer({
        vpack: "center",
        transition: "slide_left",
        reveal_child: true,
        child: downloadState,
    });
    const blockHeading = Box({
        hpack: "fill",
        class_name: "sidebar-waifu-content",
        children: [
            ...taglist.map((tag) => CommandButton(tag)),
            Box({ hexpand: true }),
            downloadIndicator,
        ],
    });
    const blockImageActions = Revealer({
        transition: "crossfade",
        reveal_child: false,
        child: Box({
            vertical: true,
            children: [
                Box({
                    class_name: "sidebar-waifu-image-actions",
                    spacing: 6,
                    children: [
                        Box({ hexpand: true }),
                        ImageAction({
                            name: "Go to source",
                            icon: icons.sideleft.link,
                            action: () =>
                                execAsync([
                                    "xdg-open",
                                    `${thisBlock.attribute.imageData.source}`,
                                ]).catch(print),
                        }),
                        ImageAction({
                            name: "Hoard",
                            icon: icons.sideleft.download,
                            action: () =>
                                execAsync([
                                    "sh",
                                    "-c",
                                    `mkdir -p ~/Pictures/homework${
                                        thisBlock.attribute.isNsfw ? "/🌶️" : ""
                                    } && cp ${
                                        thisBlock.attribute.imagePath
                                    } ~/Pictures/homework${
                                        thisBlock.attribute.isNsfw ? "/🌶️/" : ""
                                    }`,
                                ]).catch(print),
                        }),
                        ImageAction({
                            name: "Open externally",
                            icon: icons.sideleft.open,
                            action: () =>
                                execAsync([
                                    "xdg-open",
                                    `${thisBlock.attribute.imagePath}`,
                                ]).catch(console.error),
                        }),
                    ],
                }),
            ],
        }),
    });
    const blockImage = Widget.DrawingArea({
        class_name: "sidebar-waifu-image",
    });
    const blockImageRevealer = Revealer({
        transition: "slide_down",
        transition_duration: 150,
        reveal_child: false,
        child: Overlay({
            child: Box({
                homogeneous: true,
                class_name: "sidebar-waifu-image",
                children: [blockImage],
            }),
            overlays: [blockImageActions],
        }),
    });
    const thisBlock = Box({
        class_name: "sidebar-chat-message",
        attribute: {
            imagePath: "",
            isNsfw: false,
            imageData: "",
            update: (imageData, force = false) => {
                thisBlock.attribute.imageData = imageData;
                const {
                    status,
                    signature,
                    url,
                    extension,
                    source,
                    dominant_color,
                    is_nsfw,
                    width,
                    height,
                    tags,
                } = thisBlock.attribute.imageData;
                thisBlock.attribute.isNsfw = is_nsfw;
                if (status != 200) {
                    downloadState.shown = "error";
                    return;
                }
                thisBlock.attribute.imagePath = `${USER_CACHE_DIR}/ags/media/waifus/${signature}${extension}`;
                downloadState.shown = "download";
                // Width/height
                const widgetWidth = Math.min(
                    Math.floor(waifuContent.get_allocated_width() * 0.85),
                    width,
                );
                const widgetHeight = Math.ceil((widgetWidth * height) / width);
                blockImage.set_size_request(widgetWidth, widgetHeight);
                const showImage = () => {
                    downloadState.shown = "done";
                    const pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(
                        thisBlock.attribute.imagePath,
                        widgetWidth,
                        widgetHeight,
                    );
                    // const pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(thisBlock.attribute.imagePath, widgetWidth, widgetHeight, false);

                    blockImage.set_size_request(widgetWidth, widgetHeight);
                    blockImage.connect("draw", (widget, cr) => {
                        const borderRadius = widget
                            .get_style_context()
                            .get_property(
                                "border-radius",
                                Gtk.StateFlags.NORMAL,
                            );

                        // Draw a rounded rectangle
                        cr.arc(
                            borderRadius,
                            borderRadius,
                            borderRadius,
                            Math.PI,
                            1.5 * Math.PI,
                        );
                        cr.arc(
                            widgetWidth - borderRadius,
                            borderRadius,
                            borderRadius,
                            1.5 * Math.PI,
                            2 * Math.PI,
                        );
                        cr.arc(
                            widgetWidth - borderRadius,
                            widgetHeight - borderRadius,
                            borderRadius,
                            0,
                            0.5 * Math.PI,
                        );
                        cr.arc(
                            borderRadius,
                            widgetHeight - borderRadius,
                            borderRadius,
                            0.5 * Math.PI,
                            Math.PI,
                        );
                        cr.closePath();
                        cr.clip();

                        // Paint image as bg
                        Gdk.cairo_set_source_pixbuf(cr, pixbuf, 0, 0);
                        cr.paint();
                    });

                    // Reveal stuff
                    Utils.timeout(IMAGE_REVEAL_DELAY, () => {
                        blockImageRevealer.reveal_child = true;
                    });
                    Utils.timeout(
                        IMAGE_REVEAL_DELAY +
                            blockImageRevealer.transition_duration,
                        () => (blockImageActions.reveal_child = true),
                    );
                    downloadIndicator.hide();
                };
                // Show
                if (!force && fileExists(thisBlock.attribute.imagePath))
                    showImage();
                else
                    Utils.execAsync([
                        "sh",
                        "-c",
                        `wget -O '${thisBlock.attribute.imagePath}' '${url}'`,
                    ])
                        .then(showImage)
                        .catch(console.error);
                blockHeading.get_children().forEach((child) => {
                    child.setCss(`border-color: ${dominant_color};`);
                });
                colorIndicator.css = `background-color: ${dominant_color};`;
            },
        },
        children: [
            colorIndicator,
            Box({
                vertical: true,
                children: [
                    blockHeading,
                    Box({
                        vertical: true,
                        hpack: "start",
                        children: [blockImageRevealer],
                    }),
                ],
            }),
        ],
    });
    return thisBlock;
};

const WaifuInfo = () => {
    const waifuLogo = Widget.Icon({
        hpack: "center",
        class_name: "sidebar-chat-welcome-logo",
        icon: icons.sideleft.waifus,
    });
    return Box({
        vertical: true,
        vexpand: true,
        class_name: "sidebar-chat-info",
        children: [
            waifuLogo,
            Label({
                class_name: "sidebar-chat-welcome-txt",
                wrap: true,
                justify: Gtk.Justification.CENTER,
                label: "Waifus",
            }),
            Box({
                hpack: "center",
                children: [
                    Label({
                        wrap: true,
                        justify: Gtk.Justification.CENTER,
                        label: "Powered by waifu.im",
                    }),
                    Button({
                        class_name: "txt-subtext txt-norm icon-material",
                        label: "info",
                        tooltip_text:
                            "A free Waifu API. An alternative to waifu.pics.",
                        setup: setupCursorHoverInfo,
                    }),
                ],
            }),
        ],
    });
};

const waifuWelcome = Box({
    vexpand: true,
    homogeneous: true,
    child: Box({
        vpack: "center",
        vertical: true,
        children: [WaifuInfo()],
    }),
});

const waifuContent = Box({
    vertical: true,
    attribute: {
        map: new Map(),
    },
    setup: (self) =>
        self
            .hook(
                WaifuService,
                (box, id) => {
                    if (id === undefined) return;
                    const newImageBlock = WaifuImage(WaifuService.queries[id]);
                    box.add(newImageBlock);
                    box.show_all();
                    box.attribute.map.set(id, newImageBlock);
                },
                "newResponse",
            )
            .hook(
                WaifuService,
                (box, id) => {
                    if (id === undefined) return;
                    const data = WaifuService.responses[id];
                    if (!data) return;
                    const imageBlock = box.attribute.map.get(id);
                    imageBlock.attribute.update(data);
                },
                "updateResponse",
            ),
});

export const waifuView = Scrollable({
    class_name: "sidebar-chat-viewport",
    vexpand: true,
    child: Box({
        vertical: true,
        children: [waifuWelcome, waifuContent],
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

const waifuTags = Revealer({
    reveal_child: false,
    transition: "crossfade",
    transition_duration: 150,
    child: Box({
        children: [
            Scrollable({
                vscroll: "never",
                hscroll: "automatic",
                hexpand: true,
                child: Box({
                    class_name: "tags",
                    spacing: 12,
                    children: [
                        CommandButton("waifu"),
                        CommandButton("maid"),
                        CommandButton("uniform"),
                        CommandButton("oppai"),
                        CommandButton("selfies"),
                        CommandButton("marin-kitagawa"),
                        CommandButton("mori-calliope"),
                    ],
                }),
            }),
            Box({ class_name: "separator-line" }),
        ],
    }),
});

export const waifuCommands = Box({
    class_name: "commands",
    setup: (self) => {
        self.pack_end(CommandButton("/clear"), false, false, 0);
        self.pack_start(
            Button({
                class_name: "sidebar-chat-chip",
                setup: setupCursorHover,
                label: "Tags →",
                on_clicked: () => {
                    waifuTags.reveal_child = !waifuTags.reveal_child;
                },
            }),
            false,
            false,
            0,
        );
        self.pack_start(waifuTags, true, true, 0);
    },
});

const clearChat = () => {
    waifuContent.attribute.map.clear();
    const kids = waifuContent.get_children();
    for (let i = 0; i < kids.length; i++) {
        const child = kids[i];
        if (child) child.destroy();
    }
};

const DummyTag = (width, height, url, color = "#9392A6") => {
    return {
        // Needs timeout or inits won't make it
        status: 200,
        url: url,
        extension: "",
        signature: 0,
        source: url,
        dominant_color: color,
        is_nsfw: false,
        width: width,
        height: height,
        tags: ["/test"],
    };
};

export const sendMessage = (text) => {
    // Do something on send
    // Commands
    if (text.startsWith("/")) {
        if (text.startsWith("/clear")) clearChat();
        else if (text.startsWith("/test")) {
            const newImage = WaifuImage(["/test"]);
            waifuContent.add(newImage);
            Utils.timeout(IMAGE_REVEAL_DELAY, () =>
                newImage.attribute.update(
                    DummyTag(300, 200, "https://picsum.photos/600/400"),
                    true,
                ),
            );
        } else if (text.startsWith("/chino")) {
            const newImage = WaifuImage(["/chino"]);
            waifuContent.add(newImage);
            Utils.timeout(IMAGE_REVEAL_DELAY, () =>
                newImage.attribute.update(
                    DummyTag(
                        300,
                        400,
                        "https://chino.pages.dev/chino",
                        "#B2AEF3",
                    ),
                    true,
                ),
            );
        }
    } else WaifuService.fetch(text);
};
