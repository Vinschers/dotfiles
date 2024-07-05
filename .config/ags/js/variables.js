import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

export const cpu = Variable(0, {
    listen: App.configDir + "/scripts/cpu.sh",
});

export const temp = Variable(0, {
    listen: App.configDir + "/scripts/temp.sh",
});

export const ram = Variable(0, {
    listen: App.configDir + "/scripts/ram.sh",
});

export const gpu = Variable(0, {
    listen: App.configDir + "/scripts/gpu.sh",
});
