const { Gtk } = imports.gi;
import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
const { execAsync, exec } = Utils;
import {
    execAndClose,
    expandTilde,
    hasUnterminatedBackslash,
    couldBeMath,
    launchCustomCommand,
    ls,
} from "./miscfunctions.js";
import {
    CalculationResultButton,
    CustomCommandButton,
    DirectoryButton,
    DesktopEntryButton,
    ExecuteCommandButton,
    SearchButton,
} from "./searchbuttons.js";
import OverviewHyprland from "./overview_hyprland.js";
import icons from "../icons.js";

// Add math funcs
const { abs, sin, cos, tan, cot, asin, acos, atan, acot } = Math;
const pi = Math.PI;
// trigonometric funcs for deg
const sind = (x) => sin((x * pi) / 180);
const cosd = (x) => cos((x * pi) / 180);
const tand = (x) => tan((x * pi) / 180);
const cotd = (x) => cot((x * pi) / 180);
const asind = (x) => (asin(x) * 180) / pi;
const acosd = (x) => (acos(x) * 180) / pi;
const atand = (x) => (atan(x) * 180) / pi;
const acotd = (x) => (acot(x) * 180) / pi;

const MAX_RESULTS = 10;

function iconExists(iconName) {
    let iconTheme = Gtk.IconTheme.get_default();
    return iconTheme.has_icon(iconName);
}

const OptionalOverview = (monitor) => {
    try {
        return OverviewHyprland(monitor);
    } catch {
        return Widget.Box({});
        // return (await import('./overview_hyprland.js')).default();
    }
};

export const SearchAndWindows = (monitor) => {
    const overviewContent = OptionalOverview(monitor);

    var _appSearchResults = [];

    const ClickToClose = ({ ...props }) =>
        Widget.EventBox({
            ...props,
            on_primary_click: () => App.closeWindow(`overview${monitor}`),
            on_secondary_click: () => App.closeWindow(`overview${monitor}`),
            on_middle_click: () => App.closeWindow(`overview${monitor}`),
        });
    const resultsBox = Widget.Box({
        class_name: "overview-search-results",
        vertical: true,
    });
    const resultsRevealer = Widget.Revealer({
        transition_duration: 200,
        reveal_child: false,
        transition: "slide_down",
        // duration: 200,
        hpack: "center",
        child: Widget.Scrollable({
            class_name: "overview-search-results-scrollable",
            hscroll: "never",
            child: resultsBox,
        }),
    });
    const entryPromptRevealer = Widget.Revealer({
        class_name: "overview-search-prompt",
        transition: "crossfade",
        transition_duration: 150,
        reveal_child: false,
        hpack: "center",
        child: Widget.Label({
            label: "Type to search",
        }),
    });

    const entryIconRevealer = Widget.Revealer({
        transition: "crossfade",
        transition_duration: 150,
        reveal_child: false,
        hpack: "end",
        child: Widget.Icon({
            class_name: "overview-search-icon",
            icon: icons.overview.search,
        }),
    });

    const entryIcon = Widget.Box({
        class_name: "overview-search-prompt-box",
        setup: (box) => box.pack_start(entryIconRevealer, true, true, 0),
    });

    const entry = Widget.Entry({
        class_name: "overview-search-box",
        hpack: "center",
        on_accept: (self) => {
            // This is when you hit Enter
            const text = self.text;
            if (text.length == 0) return;
            const isAction = text.startsWith(">");
            const isDir = ["/", "~"].includes(entry.text[0]);

            if (couldBeMath(text)) {
                // Eval on typing is dangerous, this is a workaround
                try {
                    const fullResult = eval(text);
                    // copy
                    execAsync(["wl-copy", `${fullResult}`]).catch(print);
                    App.closeWindow(`overview${monitor}`);
                    return;
                } catch (e) {
                    // console.log(e);
                }
            }
            if (isDir) {
                App.closeWindow(`overview${monitor}`);
                execAsync([
                    "sh",
                    "-c",
                    `xdg-open "${expandTilde(text)}"`,
                    `&`,
                ]).catch(print);
                return;
            }
            if (_appSearchResults.length > 0) {
                App.closeWindow(`overview${monitor}`);
                _appSearchResults[0].launch();
                return;
            } else if (text[0] == ">") {
                // Custom commands
                App.closeWindow(`overview${monitor}`);
                launchCustomCommand(text);
                return;
            }
            // Fallback: Execute command
            if (
                !isAction &&
                exec(`sh -c "command -v ${text.split(" ")[0]}"`) != ""
            ) {
                if (text.startsWith("sudo")) execAndClose(text, true);
                else execAndClose(text, false);
            } else {
                App.closeWindow(`overview${monitor}`);
                execAsync([
                    "sh",
                    "-c",
                    `xdg-open 'https://www.google.com/search?q=${text} -site:quora.com' &`,
                ]).catch(print); // quora is useless
            }
        },
        on_change: (entry) => {
            // this is when you type
            const isAction = entry.text[0] == ">";
            const isDir = ["/", "~"].includes(entry.text[0]);
            resultsBox.get_children().forEach((ch) => ch.destroy());

            // check empty if so then dont do stuff
            if (entry.text == "") {
                resultsRevealer.reveal_child = false;
                overviewContent.reveal_child = true;
                entryPromptRevealer.reveal_child = true;
                entryIconRevealer.reveal_child = false;
                entry.toggleClassName("overview-search-box-extended", false);
                return;
            }
            const text = entry.text;
            resultsRevealer.reveal_child = true;
            overviewContent.reveal_child = false;
            entryPromptRevealer.reveal_child = false;
            entryIconRevealer.reveal_child = true;
            entry.toggleClassName("overview-search-box-extended", true);
            _appSearchResults = Applications.query(text);

            // Calculate
            if (couldBeMath(text)) {
                // Eval on typing is dangerous; this is a small workaround.
                try {
                    const fullResult = eval(text);
                    resultsBox.add(
                        CalculationResultButton(monitor, {
                            result: fullResult,
                            text: text,
                        }),
                    );
                } catch (e) {
                    // console.log(e);
                }
            }
            if (isDir) {
                var contents = [];
                contents = ls({ path: text, silent: true });
                contents.forEach((item) => {
                    resultsBox.add(DirectoryButton(monitor, item));
                });
            }
            if (isAction) {
                // Eval on typing is dangerous, this is a workaround.
                resultsBox.add(
                    CustomCommandButton(monitor, { text: entry.text }),
                );
            }
            // Add application entries
            let appsToAdd = MAX_RESULTS;
            _appSearchResults.forEach((app) => {
                if (appsToAdd == 0) return;
                resultsBox.add(DesktopEntryButton(monitor, app));
                appsToAdd--;
            });

            // Fallbacks
            // if the first word is an actual command
            if (
                !isAction &&
                !hasUnterminatedBackslash(text) &&
                exec(`sh -c "command -v ${text.split(" ")[0]}"`) != ""
            ) {
                resultsBox.add(
                    ExecuteCommandButton(monitor, {
                        command: entry.text,
                        terminal: entry.text.startsWith("sudo"),
                    }),
                );
            }

            // Add fallback: search
            resultsBox.add(SearchButton(monitor, { text: entry.text }));
            resultsBox.show_all();
        },
    });
    return Widget.Box({
        vertical: true,
        children: [
            ClickToClose({
                // Top margin. Also works as a click-outside-to-close thing
                child: Widget.Box({
                    class_name: "bar-height",
                }),
            }),
            Widget.Box({
                class_name: "overview",
                vertical: true,
                children: [
                    Widget.Box({
                        hpack: "center",
                        class_name: "overview-search",
                        child: Widget.Overlay({
                            child: entry,
                            hpack: "center",
                            overlays: [entryPromptRevealer, entryIcon],
                        }),
                    }),
                    overviewContent,
                    resultsRevealer,
                ],
            }),
        ],
        setup: (self) =>
            self
                .hook(App, (_b, name, visible) => {
                    if (name == `overview${monitor}` && !visible) {
                        resultsBox.children = [];
                        entry.set_text("");
                    }
                })
                .on("key-press-event", (widget, event) => {
                    // Typing
                    if (
                        event.get_keyval()[1] >= 32 &&
                        event.get_keyval()[1] <= 126 &&
                        widget != entry
                    ) {
                        Utils.timeout(1, () => entry.grab_focus());
                        entry.set_text(
                            entry.text +
                                String.fromCharCode(event.get_keyval()[1]),
                        );
                        entry.set_position(-1);
                    }
                }),
    });
};
