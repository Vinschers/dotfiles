import icons from "../icons.js";
import Bluetooth from "resource:///com/github/Aylur/ags/service/bluetooth.js";
import Network from "resource:///com/github/Aylur/ags/service/network.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const BluetoothIndicator = () =>
    Widget.Label({
        label: Bluetooth.bind("enabled").transform((on) =>
            on ? icons.bluetooth.enabled : icons.bluetooth.disabled,
        ),
    });

const WifiIndicator = () => Widget.Box({
    children: [
        Widget.Icon({
            icon: Network.wifi.bind('icon_name'),
        }),
        Widget.Label({
            label: Network.wifi.bind('ssid').transform(v => v?.toString() || ""),
        }),
    ],
})

const WiredIndicator = () => Widget.Icon({
    icon: Network.wired.bind('icon_name').transform(v => v?.toString() || ""),
})

const NetworkIndicator = () => Widget.Stack({
    items: [
        ['wifi', WifiIndicator()],
        ['wired', WiredIndicator()],
    ],
    shown: Network.bind('primary').transform(p => p || 'wifi').transform(v => v?.toString() || ""),
})

const Configurations = () =>
    Widget.Button({
        class_name: "configurations",
        child: Widget.Box({
            spacing: 6,
            children: [BluetoothIndicator(), NetworkIndicator()],
        }),
    });

console.log(Network);

export default Configurations;
