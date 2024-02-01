import icons from "../icons.js";
import Brightness from "../../services/brightness.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const BrightnessSlider = () =>
    Widget.Slider({
        class_name: "brightness-box",
        draw_value: false,
        on_change: ({ value }) => (Brightness.screen = value),
    }).bind("value", Brightness, "screen");

export default () =>
    Widget.Box({
        class_name: "slider",
        spacing: 16,
        children: [
            Widget.Icon({
                icon: icons.brightness.indicator.on,
                class_name: "slider-tooltip",
            }).bind(
                "tooltip-text",
                Brightness,
                "screen",
                (v) => `Screen Brightness: ${Math.floor(v * 100)}%`,
            ),
            BrightnessSlider(),
        ],
    }).bind("visible", Brightness, "screen");
