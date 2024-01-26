import icons from "../icons.js";
import { SimpleToggleButton } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

export default () => {
    const record = Variable(false);

    return SimpleToggleButton({
        icon: Widget.Icon(icons.recorder.recording),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Record",
        }),
        status: Widget.Label({
            hpack: "start",
        }).hook(record, (label) => {
            label.label = record.value ? "Recording" : "Click to start";
        }),
        // @ts-ignore
        toggle: () => {
            record.value = !record.value;

            Utils.execAsync(`sh -c ${App.configDir}/scripts/record.sh`);
        },
        connection: [record, () => record.value],
    });
};
