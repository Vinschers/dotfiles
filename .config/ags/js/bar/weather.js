import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import WeatherService from "../../services/weather.js";

const Weather = () =>
    Widget.Button({
        on_clicked: () => Utils.execAsync("weather-gtk4"),
        child: Widget.Box({
            class_name: "weather",
            spacing: 16,
            visible: WeatherService.bind("icon").transform(
                (icon) => icon !== "",
            ),
            children: [
                Widget.Label({
                    class_name: "weather-icon",
                }).bind("label", WeatherService, "icon"),
                Widget.Label({
                    class_name: "weather-temp",
                    label: WeatherService.bind("temp").transform(
                        (temp) => temp + "°C",
                    ),
                }),
            ],
        }).bind("tooltip_markup", WeatherService, "description"),
    });

export default Weather;
