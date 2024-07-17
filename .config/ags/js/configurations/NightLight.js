import icons from "../icons.js";
import { SimpleToggleButton } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

export default () => {
    const nightlight = Variable(false);

    return SimpleToggleButton({
        icon: Widget.Icon({}).hook(nightlight, (icon) => {
            icon.icon = !nightlight.value
                ? icons.nightlight.disabled
                : icons.nightlight.enabled;
        }),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Night Light",
        }),
        status: Widget.Label({
            hpack: "start",
        }).hook(nightlight, (label) => {
            label.label = nightlight.value ? "Enabled" : "Disabled";
        }),
        // @ts-ignore
        toggle: () => {
            nightlight.value = !nightlight.value;

            Utils.execAsync(
                `sh -c '${App.configDir}/scripts/toggle-nightlight.sh ${nightlight.value}'`,
            );
        },
        connection: [nightlight, () => nightlight.value],
    });
};
