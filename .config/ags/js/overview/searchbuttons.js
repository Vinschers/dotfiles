const { Gtk } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
const { execAsync, exec } = Utils;
import { searchItem } from "./searchitem.js";
import {
    execAndClose,
    couldBeMath,
    launchCustomCommand,
} from "./miscfunctions.js";

export const DirectoryButton = ({ parentPath, name, type, icon }) => {
    const actionText = Widget.Revealer({
        reveal_child: false,
        transition: "crossfade",
        transition_duration: 200,
        child: Widget.Label({
            class_name: "overview-search-results-txt txt txt-small txt-action",
            label: "Open",
        }),
    });
    const actionTextRevealer = Widget.Revealer({
        reveal_child: false,
        transition: "slide_left",
        transition_duration: 300,
        child: actionText,
    });
    return Widget.Button({
        class_name: "overview-search-result-btn",
        on_clicked: () => {
            App.closeWindow("overview");
            execAsync([
                "bash",
                "-c",
                `xdg-open '${parentPath}/${name}'`,
                `&`,
            ]).catch(print);
        },
        child: Widget.Box({
            children: [
                Widget.Box({
                    vertical: false,
                    children: [
                        Widget.Box({
                            class_name: "overview-search-results-icon",
                            homogeneous: true,
                            child: Widget.Icon({
                                icon: icon,
                                setup: (self) =>
                                    Utils.timeout(1, () => {
                                        const styleContext = self
                                            .get_parent()
                                            .get_style_context();
                                        const width = styleContext.get_property(
                                            "min-width",
                                            Gtk.StateFlags.NORMAL,
                                        );
                                        const height =
                                            styleContext.get_property(
                                                "min-height",
                                                Gtk.StateFlags.NORMAL,
                                            );
                                        self.size = Math.max(width, height, 1);
                                    }),
                            }),
                        }),
                        Widget.Label({
                            class_name:
                                "overview-search-results-txt txt txt-norm",
                            label: name,
                        }),
                        Widget.Box({ hexpand: true }),
                        actionTextRevealer,
                    ],
                }),
            ],
        }),
        setup: (self) =>
            self
                .on("focus-in-event", (button) => {
                    actionText.reveal_child = true;
                    actionTextRevealer.reveal_child = true;
                })
                .on("focus-out-event", (button) => {
                    actionText.reveal_child = false;
                    actionTextRevealer.reveal_child = false;
                }),
    });
};

export const CalculationResultButton = ({ result, text }) =>
    searchItem({
        materialIconName: "calculate",
        name: `Math result`,
        actionName: "Copy",
        content: `${result}`,
        onActivate: () => {
            App.closeWindow("overview");
            execAsync(["wl-copy", `${result}`]).catch(print);
        },
    });

export const DesktopEntryButton = (app) => {
    const actionText = Widget.Revealer({
        reveal_child: false,
        transition: "crossfade",
        transition_duration: 200,
        child: Widget.Label({
            class_name: "overview-search-results-txt txt txt-small txt-action",
            label: "Launch",
        }),
    });
    const actionTextRevealer = Widget.Revealer({
        reveal_child: false,
        transition: "slide_left",
        transition_duration: 300,
        child: actionText,
    });
    return Widget.Button({
        class_name: "overview-search-result-btn",
        on_clicked: () => {
            App.closeWindow("overview");
            app.launch();
        },
        child: Widget.Box({
            children: [
                Widget.Box({
                    vertical: false,
                    children: [
                        Widget.Box({
                            class_name: "overview-search-results-icon",
                            homogeneous: true,
                            child: Widget.Icon({
                                icon: app.iconName,
                                setup: (self) =>
                                    Utils.timeout(1, () => {
                                        const styleContext = self
                                            .get_parent()
                                            .get_style_context();
                                        const width = styleContext.get_property(
                                            "min-width",
                                            Gtk.StateFlags.NORMAL,
                                        );
                                        const height =
                                            styleContext.get_property(
                                                "min-height",
                                                Gtk.StateFlags.NORMAL,
                                            );
                                        self.size = Math.max(width, height, 1);
                                    }),
                            }),
                        }),
                        Widget.Label({
                            class_name:
                                "overview-search-results-txt txt txt-norm",
                            label: app.name,
                        }),
                        Widget.Box({ hexpand: true }),
                        actionTextRevealer,
                    ],
                }),
            ],
        }),
        setup: (self) =>
            self
                .on("focus-in-event", (button) => {
                    actionText.reveal_child = true;
                    actionTextRevealer.reveal_child = true;
                })
                .on("focus-out-event", (button) => {
                    actionText.reveal_child = false;
                    actionTextRevealer.reveal_child = false;
                }),
    });
};

export const ExecuteCommandButton = ({ command, terminal = false }) =>
    searchItem({
        materialIconName: `${terminal ? "terminal" : "settings_b_roll"}`,
        name: `Run command`,
        actionName: `Execute ${terminal ? "in terminal" : ""}`,
        content: `${command}`,
        onActivate: () => execAndClose(command, terminal),
    });

export const CustomCommandButton = ({ text = "" }) =>
    searchItem({
        materialIconName: "settings_suggest",
        name: "Action",
        actionName: "Run",
        content: `${text}`,
        onActivate: () => {
            App.closeWindow("overview");
            launchCustomCommand(text);
        },
    });

export const SearchButton = ({ text = "" }) =>
    searchItem({
        materialIconName: "travel_explore",
        name: "Search Google",
        actionName: "Go",
        content: `${text}`,
        onActivate: () => {
            App.closeWindow("overview");
            execAsync([
                "bash",
                "-c",
                `xdg-open 'https://www.google.com/search?q=${text} -site:quora.com' &`,
            ]).catch(print); // quora is useless
        },
    });
