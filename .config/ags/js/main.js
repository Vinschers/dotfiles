import App from "resource:///com/github/Aylur/ags/app.js";
import Bar from "./bar/main.js";
import { forMonitors } from "./utils.js";

const windows = () => [forMonitors(Bar)];

export default {
    windows: windows().flat(1),
    style: App.configDir + "/style.css",
};
