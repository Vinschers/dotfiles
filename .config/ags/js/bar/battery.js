import Battery from "resource:///com/github/Aylur/ags/service/battery.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const BatteryWidget = () =>
    Widget.CircularProgress({
        class_name: Battery.bind("charging").transform((ch) => {
            return `battery ${ch ? "charging" : ""}`;
        }),
        child: Widget.Icon({
            icon: Battery.bind("icon_name").transform(
                (v) => v?.toString() || "object-select-symbolic",
            ),
        }),
        visible: Battery.bind("available"),
        value: Battery.bind("percent").transform((p) => (p > 0 ? p / 100 : 0)),
    });

export default BatteryWidget;
