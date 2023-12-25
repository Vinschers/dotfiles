import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { exec } from "resource:///com/github/Aylur/ags/utils.js";

const languages = [
    {
        layout: "en",
        name: "English",
    },
    {
        layout: "pt",
        name: "Portuguese",
    },
    {
        layout: "de",
        name: "Deutsch",
    },
    {
        layout: "fr",
        name: "French",
    },
    {
        layout: "jp",
        name: "Japanese",
    },
    {
        layout: "undef",
        name: "Undefined",
        flag: "🧐",
    },
];

const get_initial_layout = () => {
    const keyboards = JSON.parse(exec("hyprctl -j devices")).keyboards;

    const layouts = {};
    keyboards.forEach((keyboard) => {
        layouts[keyboard.layout] = keyboard.active_keymap;
    });

    delete layouts["us"];
    let keymap = layouts[Object.keys(layouts)[0]] || "English";

    let lang = languages.find((lang) => keymap.includes(lang.name));
    if (lang) return lang.layout;

    return "en";
};

const Keyboard = () => {
    const keyboard = Widget.Button({
        class_name: "keyboard",
        child: Widget.Label().hook(
            Hyprland,
            (self, kb_name, layout_name) => {
                if (!kb_name) return;

                let lang = languages.find((lang) =>
                    layout_name.includes(lang.name),
                );

                if (lang) self.label = lang.layout;
            },
            "keyboard-layout",
        ),
    });

    keyboard.child.label = get_initial_layout();

    return keyboard;
};

export default Keyboard;
