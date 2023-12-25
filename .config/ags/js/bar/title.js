import Pango10 from "gi://Pango";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

const Title = (monitor) =>
    Widget.Label({
        class_name: "title",
        ellipsize: Pango10.EllipsizeMode.END,
    })
        .hook(Hyprland.active.client, (self) => {
            const client = Hyprland.getClient(Hyprland.active.client.address);

            if (!client && Hyprland.active.monitor.id == monitor)
                self.label = "";
            else if (client && client.monitor == monitor)
                self.label = client.title || client.class;
        })
        .hook(
            Hyprland,
            (self, addr) => {
                const client = Hyprland.getClient(`${addr}`);

                if (client && client.monitor == monitor)
                    self.label = client.title || client.class;
            },
            "client-added",
        );

export default Title;
