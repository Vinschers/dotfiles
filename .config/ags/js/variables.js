import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

const MAX_HIST = 600;
const add_hist = (hist, v) => {
    hist.push(v);
    if (hist.length > MAX_HIST) hist.splice(0, 1);
    return v;
};

export const cpu_hist = [];
export const cpu = Variable(0, {
    listen: [
        App.configDir + "/scripts/cpu.sh",
        (value) => add_hist(cpu_hist, Number(value)),
    ],
});

export const temp_hist = [];
export const temp = Variable(0, {
    listen: [
        App.configDir + "/scripts/temp.sh",
        (value) => add_hist(temp_hist, Number(value)),
    ],
});

export const ram_hist = [];
export const ram = Variable(0, {
    listen: [
        App.configDir + "/scripts/ram.sh",
        (value) => add_hist(ram_hist, Number(value)),
    ],
});

export const gpu_hist = [];
export const gpu = Variable(0, {
    listen: [
        App.configDir + "/scripts/gpu.sh",
        (value) => add_hist(gpu_hist, Number(value)),
    ],
});
