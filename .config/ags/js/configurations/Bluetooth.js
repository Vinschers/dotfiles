import icons from "../icons.js";
import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import { Menu, ArrowToggleButton } from "./ToggleButton.js";

export const BluetoothToggle = () =>
    ArrowToggleButton({
        name: "bluetooth",
        icon: Widget.Icon({}).hook(Bluetooth, (icon) => {
            icon.icon = Bluetooth.enabled
                ? icons.bluetooth.enabled
                : icons.bluetooth.disabled;
        }),
        label: Widget.Label({
            class_name: "title",
            hpack: "start",
            label: "Bluetooth",
        }),
        status: Widget.Label({
            hpack: "start",
            truncate: "end",
        }).hook(Bluetooth, (label) => {
            if (!Bluetooth.enabled) return (label.label = "Disabled");

            if (Bluetooth.connected_devices.length === 0)
                return (label.label = "Not Connected");

            if (Bluetooth.connected_devices.length === 1)
                return (label.label = Bluetooth.connected_devices[0].alias);

            label.label = `${Bluetooth.connected_devices.length} Connected`;
        }),
        connection: [Bluetooth, () => Bluetooth.enabled],
        deactivate: () => (Bluetooth.enabled = false),
        activate: () => (Bluetooth.enabled = true),
    });

export const BluetoothDevices = () =>
    Menu({
        name: "bluetooth",
        icon: Widget.Icon(icons.bluetooth.disabled),
        title: Widget.Label("Bluetooth"),
        settings: Widget.Button({
            cursor: "pointer",
            on_clicked: () => Applications.query("blueberry")?.[0].launch(),
            child: Widget.Box({
                child: Widget.Icon(icons.settings),
            }),
        }),
        menu_content: [
            Widget.Box({
                hexpand: true,
                vertical: true,
            }).hook(Bluetooth, (box) => {
                try {
                    box.children = Bluetooth.devices
                        .filter((d) => d.name)
                        .map((device) =>
                            Widget.Button({
                                cursor: "pointer",
                                class_name: "bt-entry",
                                on_clicked: () =>
                                    device.setConnection(!device.connected),
                                child: Widget.Box({
                                    children: [
                                        Widget.Icon(
                                            device.icon_name + "-symbolic",
                                        ),
                                        Widget.Label(device.name),
                                        device.battery_percentage > 0 &&
                                            Widget.Label({
                                                class_name: "bt-battery",
                                                label: `󱐋  ${device.battery_percentage}%`,
                                            }),
                                        Widget.Box({
                                            hexpand: true,
                                        }),
                                        device.connecting
                                            ? Widget.Spinner({
                                                  active: true,
                                              })
                                            : device.connected &&
                                              Widget.Icon({
                                                  icon: icons.tick,
                                                  hexpand: true,
                                                  hpack: "end",
                                              }),
                                    ],
                                }),
                            }),
                        );

                    if (box.children.length == 0)
                        box.children = [
                            Widget.Box({
                                hpack: "center",
                                hexpand: true,
                                child: Widget.Label({
                                    class_name: "no-content",
                                    label: "Not devices found.",
                                }),
                            }),
                        ];
                } catch (error) {
                    box.children = [
                        Widget.Box({
                            hpack: "center",
                            hexpand: true,
                            child: Widget.Label({
                                class_name: "no-content",
                                label: "Not devices found.",
                            }),
                        }),
                    ];
                }
            }),
        ],
    });
