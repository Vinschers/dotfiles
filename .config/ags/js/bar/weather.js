import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Service from "resource:///com/github/Aylur/ags/service.js";
import { interval, fetch } from "resource:///com/github/Aylur/ags/utils.js";
import icons from "../icons.js";

class WeatherService extends Service {
    static {
        Service.register(
            this,
            {},
            {
                "feels-like": ["int"],
                temp: ["int"],
                icon: ["string"],
                description: ["string"],
                "weather-data": ["jsobject"],
            },
        );
    }

    _feels_like = 0;
    _temp = 0;
    _description = "";
    _icon = "";
    _weather_data = {};
    _url = "http://wttr.in/?format=j1";
    _decoder = new TextDecoder();

    get feels_like() {
        return this._feels_like;
    }

    get temp() {
        return this._temp;
    }

    get icon() {
        return this._icon;
    }

    get description() {
        return this._description;
    }

    get weather_data() {
        return this._weather_data;
    }

    constructor() {
        super();
        interval(900000, this._getWeather.bind(this)); // every 15 min
    }

    _getWeather() {
        fetch(this._url)
            .then((result) => result.json())
            .then((result) => {
                const weatherData = result;
                this.updateProperty("weather_data", weatherData);
                this.updateProperty(
                    "feels_like",
                    Number(weatherData["current_condition"][0]["FeelsLikeC"]),
                );
                this.updateProperty(
                    "temp",
                    Number(weatherData["current_condition"][0]["temp_C"]),
                );
                this.updateProperty(
                    "description",
                    weatherData["current_condition"][0]["weatherDesc"][0][
                        "value"
                    ],
                );
                const weatherCode =
                    weatherData["current_condition"][0]["weatherCode"];
                const sunriseHour =
                    weatherData["weather"][0]["astronomy"][0]["sunrise"].split(
                        ":",
                    )[0];
                const sunsetHour =
                    weatherData["weather"][0]["astronomy"][0]["sunset"].split(
                        ":",
                    )[0];
                const curHour = new Date().getHours();
                const timeOfDay =
                    curHour >= sunriseHour && curHour <= sunsetHour + 12
                        ? "day"
                        : "night";
                this.updateProperty(
                    "icon",
                    icons.weather[timeOfDay][weatherCode] ||
                        icons.weather["day"][weatherCode] || // fallback to day
                        "",
                );
            })
            .catch(logError);
    }
}

const Weather = () => {
    const weather_service = new WeatherService();

    return Widget.Box({
        class_name: "weather",
        spacing: 16,
        visible: weather_service.bind("icon").transform((icon) => icon !== ""),
        children: [
            Widget.Label({
                class_name: "weather-icon",
                label: weather_service.bind("icon"),
            }),
            Widget.Label({
                class_name: "weather-temp",
                label: weather_service
                    .bind("temp")
                    .transform((temp) => temp + "°C"),
            }),
        ],
        tooltip_markup: weather_service.bind("description"),
    });
};

export default Weather;
