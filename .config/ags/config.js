"strict mode";

import Gdk from "gi://Gdk";
import App from "resource:///com/github/Aylur/ags/app.js";
import { exec } from "resource:///com/github/Aylur/ags/utils.js";
import DirectoryMonitorService from "./directoryMonitorService.js";

import Bar from "./js/bar/config.js";
import Configurations from "./js/configurations/config.js";
import Calendar from "./js/calendar/config.js";
import { WifiSelection } from "./js/configurations/Network.js";
import { BluetoothDevices } from "./js/configurations/Bluetooth.js";
import { AppMixer, SinkSelector } from "./js/configurations/Volume.js";

const applyScss = () => {
    // Compile scss
    exec(`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`);
    console.log("Scss compiled");

    // Apply compiled css
    App.resetCss();
    App.applyCss(`${App.configDir}/style.css`);
    console.log("Compiled css applied");
};

/**
 * @param {(monitor: number) => any} widget
 * @returns {Array<import('types/widgets/window').default>}
 */
export function foreachMonitor(widget) {
    const num_monitors = Gdk.Display.get_default()?.get_n_monitors() || 1;

    return Array.from({ length: num_monitors }, (_, monitor) =>
        widget(monitor),
    );
}

DirectoryMonitorService.connect("changed", () => applyScss());
applyScss();

const windows = () => [
    foreachMonitor(Bar),
    Calendar(),
    Configurations(),
    WifiSelection(),
    BluetoothDevices(),
    AppMixer(),
    SinkSelector(),
];

export default {
    windows: windows().flat(1),
};
