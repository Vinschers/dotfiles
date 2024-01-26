import icons from "../icons.js";
import { Menu, ArrowToggleButton } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";

export const NetworkToggle = () =>
    ArrowToggleButton({
        name: "network",
        icon: Widget.Icon({
            connections: [
                [
                    Network,
                    (icon) => {
                        icon.icon = Network.wifi?.icon_name || "";
                    },
                ],
            ],
        }),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Network",
        }),
        status: Widget.Label({
            hpack: "start",
            connections: [
                [
                    Network,
                    (label) => {
                        label.label = Network.wifi?.ssid || "Not Connected";
                    },
                ],
            ],
        }),
        connection: [Network, () => Network.wifi?.enabled],
        deactivate: () => (Network.wifi.enabled = false),
        activate: () => {
            Network.wifi.enabled = true;
            Network.wifi.scan();
        },
    });

export const WifiSelection = () =>
    Menu({
        name: "network",
        icon: Widget.Icon({
            connections: [
                [
                    Network,
                    (icon) => {
                        icon.icon = Network.wifi.icon_name;
                    },
                ],
            ],
        }),
        title: Widget.Label("Wifi Selection"),
        menu_content: [
            Widget.Box({
                vertical: true,
                connections: [
                    [
                        Network,
                        (box) =>
                            (box.children = Network.wifi?.access_points?.map(
                                (ap) =>
                                    Widget.Button({
                                        cursor: "pointer",
                                        on_clicked: () =>
                                            Utils.execAsync(
                                                `nmcli device wifi connect ${ap.bssid}`,
                                            ),
                                        child: Widget.Box({
                                            children: [
                                                Widget.Icon(ap.iconName),
                                                Widget.Label(ap.ssid || ""),
                                                ap.active
                                                    ? Widget.Icon({
                                                          icon: icons.tick,
                                                          hexpand: true,
                                                          hpack: "end",
                                                      })
                                                    : Widget.Box(),
                                            ],
                                        }),
                                    }),
                            )),
                    ],
                ],
            }),
            Widget.Separator({}),
            Widget.Button({
                cursor: "pointer",
                on_clicked: () =>
                    Applications.query("gnome-control-center")?.[0].launch(),
                child: Widget.Box({
                    children: [
                        Widget.Icon(icons.settings),
                        Widget.Label("Network"),
                    ],
                }),
            }),
        ],
    });
