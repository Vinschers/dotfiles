import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const BatteryWidget = () =>
    Widget.Box({
        class_name: "battery",
        visible: Battery.bind("available"),
        child: Widget.CircularProgress({
            class_name: Battery.bind("percent").transform((bat) => {
                let classes = ["circprog"];

                if (Battery.available) {
                    // @ts-ignore
                    const status = [
                        [101, "full"],
                        [75, "high"],
                        [50, "medium"],
                        [20, "low"],
                    ].find(([threshold]) => Number(threshold) <= bat)[1];

                    classes.push(status.toString());
                }

                return classes.join(" ");
            }),
            child: Widget.Icon({
                icon: Battery.bind("icon_name").transform(
                    (v) => v?.toString() || "object-select-symbolic",
                ),
            }),
            value: Battery.bind("percent").transform((p) =>
                p > 0 ? p / 100 : 0,
            ),
            start_at: 0.75,
            tooltip_text: Battery.bind("percent").transform((p) =>
                p.toFixed(2),
            ),
        }),
    });
export default BatteryWidget;
