import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

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

const get_layout = () => {
    const keyboards = JSON.parse(exec("hyprctl -j devices")).keyboards;

    let keymap = "";
    keyboards.forEach((keyboard) => {
        if (keyboard.main && !keyboard.name.includes("button"))
            keymap = keyboard.active_keymap;
    });

    let lang = languages.find((lang) => keymap.includes(lang.name));
    if (lang) return lang.layout;

    return "";
};

export default () => {
    const layout = new Variable(get_layout(), {
        poll: [1000, get_layout],
    });

    return Widget.Button({
        on_clicked: () => {
            const devicesObj = JSON.parse(exec("hyprctl devices -j"));
            let keyboard = "";

            for (let i = 0; i < devicesObj.keyboards.length; i++) {
                if (devicesObj.keyboards[i].main) {
                    keyboard = devicesObj.keyboards[i].name;
                    break;
                }
            }

            if (keyboard == "") return;

            exec(`hyprctl switchxkblayout ${keyboard} next`);
        },
        visible: layout.bind().as((layout) => layout.length > 0),
        child: Widget.Label({
            class_name: "keyboard",
            yalign: 0.477,
            xalign: 0.51,
            label: layout.bind(),
        }).hook(
            Hyprland,
            (label, _, __) => {
                layout.setValue(get_layout());
            },
            "keyboard-layout",
        ),
    });
};
