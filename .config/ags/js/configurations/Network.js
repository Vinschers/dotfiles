import icons from "../icons.js";
import { Menu, ArrowToggleButton } from "./ToggleButton.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Utils from "resource:///com/github/Aylur/ags/utils.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";

export const NetworkToggle = () =>
    ArrowToggleButton({
        name: "network",
        icon: Widget.Icon({}).hook(Network, (icon) => {
            icon.icon = Network.wifi?.icon_name || "";
        }),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Network",
        }),
        status: Widget.Label({
            hpack: "start",
        }).hook(Network, (label) => {
            label.label = Network.wifi?.ssid || "Not Connected";
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
        icon: Widget.Icon({}).hook(Network, (icon) => {
            icon.icon = Network.wifi.icon_name;
        }),
        title: Widget.Label("Wifi Selection"),
        settings: Widget.Button({
            cursor: "pointer",
            on_clicked: () => Applications.query("iwgtk")?.[0].launch(),
            child: Widget.Box({
                child: Widget.Icon(icons.settings),
            }),
        }),
        menu_content: [
            Widget.Box({
                vertical: true,
            }).hook(Network, (box) => {
                try {
                    box.children = Network.wifi?.access_points?.map((ap) =>
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
                    );
                } catch (error) {
                    box.children = [
                        Widget.Box({
                            hpack: "center",
                            hexpand: true,
                            child: Widget.Label({
                                class_name: "no-content",
                                label: "Not networks found.",
                            }),
                        }),
                    ];
                }
            }),
        ],
    });
