import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const Clock = () => {
    const datetime = new Variable(["", ""], {
        poll: [1000, "date '+%H:%M;%A, %d/%m'", (output) => output.split(";")],
    });
    const hover = new Variable(false);

    const time_widget = Widget.Label({
        class_name: "time",
        label: datetime.bind().transform((dt) => dt[0]),
    });

    const separator_widget = Widget.Label({
        class_name: "separator",
        label: "🞄",
    });

    const date_widget = Widget.Label({
        class_name: "date",
        label: datetime.bind().transform((dt) => dt[1]),
    });

    const clock_widget = Widget.Box({
        class_name: "clock",
        spacing: 6,
        children: [
            time_widget,
            Widget.Revealer({
                reveal_child: hover.bind(),
                transition_duration: 250,
                transition: "slide_right",
                child: Widget.Box({
                    spacing: 6,
                    children: [separator_widget, date_widget],
                }),
            }),
        ],
    });

    return Widget.EventBox({
        on_hover: () => hover.setValue(true),
        on_hover_lost: () => hover.setValue(false),
        child: clock_widget,
    });
};

export default Clock;
