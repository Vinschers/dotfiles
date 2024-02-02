import App from "resource:///com/github/Aylur/ags/app.js";

export default {
    settings: "gnome-settings",
    tick: "object-select-symbolic",
    check: "checkbox-symbolic",
    checked: "checkbox-checked-symbolic",
    audio: {
        mic: {
            muted: "microphone-disabled-symbolic",
            unmuted: "microphone-sensitivity-high-symbolic",
        },
        volume: {
            muted: "audio-volume-muted-symbolic",
            low: "audio-volume-low-symbolic",
            medium: "audio-volume-medium-symbolic",
            high: "audio-volume-high-symbolic",
            overamplified: "audio-volume-overamplified-symbolic",
        },
        type: {
            headset: "audio-headphones-symbolic",
            speaker: "audio-speakers-symbolic",
            card: "audio-card-symbolic",
        },
        mixer: "media-playlist-shuffle-symbolic",
        sink: "",
    },
    apps: {
        apps: "view-app-grid-symbolic",
        search: "folder-saved-search-symbolic",
    },
    bluetooth: {
        enabled: "bluetooth-active-symbolic",
        disabled: "bluetooth-disabled-symbolic",
    },
    nightlight: {
        enabled: "night-light-symbolic",
        disabled: "display-brightness-high-symbolic",
    },
    brightness: {
        indicator: {
            on: "display-brightness-symbolic",
            high: "display-brightness-high-symbolic",
            medium: "display-brightness-medium-symbolic",
            low: "display-brightness-low-symbolic",
        },
        keyboard: "keyboard-brightness-symbolic",
        screen: ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"],
    },
    powermenu: {
        sleep: "weather-clear-night-symbolic",
        reboot: "system-reboot-symbolic",
        logout: "system-log-out-symbolic",
        shutdown: "system-shutdown-symbolic",
        lock: "system-lock-screen-symbolic",
        close: "window-close-symbolic",
    },
    recorder: {
        recording: "emblem-videos-symbolic",
    },
    notifications: {
        noisy: "preferences-system-notifications-symbolic",
        silent: "notifications-disabled-symbolic",
        critical: "messagebox_critical-symbolic",
        chat: "notification-symbolic",
        close: "window-close-symbolic",
    },
    footer: {
        theme: "applications-graphics-symbolic",
        wallpaper: "image-x-generic-symbolic",
        power: "system-shutdown-symbolic",
    },
    trash: {
        full: "user-trash-full-symbolic",
        empty: "user-trash-symbolic",
    },
    mpris: {
        fallback: "audio-x-generic-symbolic",
        shuffle: {
            enabled: "media-playlist-shuffle-symbolic",
            disabled: "media-playlist-no-shuffle-symbolic",
        },
        loop: {
            none: "media-playlist-no-repeat-symbolic",
            track: "media-playlist-repeat-song-symbolic",
            playlist: "media-playlist-repeat-symbolic",
        },
        playing: "media-playback-pause-symbolic",
        paused: "media-playback-start-symbolic",
        stopped: "media-playback-stop-symbolic",
        prev: "media-skip-backward-symbolic",
        next: "media-skip-forward-symbolic",
    },
    packages: "system-software-install-symbolic",
    ui: {
        send: "mail-send-symbolic",
        arrow: {
            right: "pan-end-symbolic",
            left: "pan-start-symbolic",
            down: "pan-down-symbolic",
            up: "pan-up-symbolic",
        },
    },
    sideleft: {
        apis: "package-x-generic-symbolic",
        toolbox: "preferences-other-symbolic",
        gemini: "",
        waifus: "camera-photo-symbolic",
        info: "help-about",
        send: "document-send-symbolic",
        copy: "edit-copy-symbolic",
        download: "browser-download-symbolic",
        done: "emblem-ok-symbolic",
        error: "dialog-error-symbolic",
        link: "link-symbolic",
        open: "focus-windows-symbolic",
    },
    overview: {
        search: "search",
        search_web: "web-browser-symbolic",
        calculate: "accessories-calculator-symbolic",
        terminal: "utilities-terminal-symbolic",
        settings: "preferences-system-symbolic",
        run: "system-run-symbolic",
    },
    weather: {
        day: {
            113: "", //"Sunny",
            116: "", //"PartlyCloudy",
            119: "", //"Cloudy",
            122: "", //"VeryCloudy",
            143: "", //"Fog",
            176: "", //"LightShowers",
            179: "", //"LightSleetShowers",
            182: "", //"LightSleet",
            185: "", //"LightSleet",
            200: "", //"ThunderyShowers",
            227: "", //"LightSnow",
            230: "", //"HeavySnow",
            248: "", //"Fog",
            260: "", //"Fog",
            263: "", //"LightShowers",
            266: "", //"LightRain",
            281: "", //"LightSleet",
            284: "", //"LightSleet",
            293: "", //"LightRain",
            296: "", //"LightRain",
            299: "", //"HeavyShowers",
            302: "", //"HeavyRain",
            305: "", //"HeavyShowers",
            308: "", //"HeavyRain",
            311: "", //"LightSleet",
            314: "", //"LightSleet",
            317: "", //"LightSleet",
            320: "", //"LightSnow",
            323: "", //"LightSnowShowers",
            326: "", //"LightSnowShowers",
            329: "", //"HeavySnow",
            332: "", //"HeavySnow",
            335: "", //"HeavySnowShowers",
            338: "", //"HeavySnow",
            350: "", //"LightSleet",
            353: "", //"LightShowers",
            356: "", //"HeavyShowers",
            359: "", //"HeavyRain",
            362: "", //"LightSleetShowers",
            365: "", //"LightSleetShowers",
            368: "", //"LightSnowShowers",
            371: "", //"HeavySnowShowers",
            374: "", //"LightSleetShowers",
            377: "", //"LightSleet",
            386: "", //"ThunderyShowers",
            389: "", //"ThunderyHeavyRain",
            392: "", //"ThunderySnowShowers",
            395: "", //"HeavySnowShowers",
        },
        night: {
            113: "", // Night
            116: "", // Partly cloudy, night
            119: "", // Partly cloudy, night
        },
    },
};
