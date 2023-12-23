import App from "resource:///com/github/Aylur/ags/app.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";

const MAX_HIST = 600;

export const cpu_hist = [];
export const cpu = Variable(0, {
    listen: [
        App.configDir + "/scripts/cpu.sh",
        (value) => {
            cpu_hist.push(Number(value));
            if (cpu_hist.length > MAX_HIST) cpu_hist.splice(0, 1);

            return Number(value);
        },
    ],
});

export const temp_hist = [];
export const temp = Variable(0, {
    listen: [
        App.configDir + "/scripts/temperature.sh",
        (value) => {
            temp_hist.push(Number(value));
            if (temp_hist.length > MAX_HIST) temp_hist.splice(0, 1);

            return Number(value);
        },
    ],
});

export const ram_hist = [];
export const ram = Variable(0, {
    listen: [
        App.configDir + "/scripts/ram.sh",
        (value) => {
            ram_hist.push(Number(value));
            if (ram_hist.length > MAX_HIST) ram_hist.splice(0, 1);

            return Number(value);
        },
    ],
});

export const gpu_hist = [];
export const gpu = Variable(0, {
    listen: [
        App.configDir + "/scripts/gpu.sh",
        (value) => {
            gpu_hist.push(Number(value));
            if (gpu_hist.length > MAX_HIST) gpu_hist.splice(0, 1);

            return Number(value);
        },
    ],
});
