import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

const Clock = () =>
    Widget.Box({
        class_name: "clock",
        spacing: 6,
    }).poll(1000, (self) => {
        execAsync(["date", "+%H:%M;%A, %d/%m"])
            .then((output) => {
                const [time, date] = output.split(";");

                self.children = [
                    Widget.Label({
                        class_name: "time",
                        label: time,
                    }),
                    Widget.Label({
                        class_name: "separator",
                        label: "🞄",
                    }),
                    Widget.Label({
                        class_name: "date",
                        label: date,
                    }),
                ];
            })
            .catch(console.error);
    });

export default Clock;
