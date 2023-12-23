import Widget from "resource:///com/github/Aylur/ags/widget.js";

import icons from "../icons.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";

const Packages = () => {
    const packages = Widget.Button({
        child: Widget.Box({
            class_name: "packages",
            children: [Widget.Icon(icons.packages), Widget.Label()],
            connections: [
                [
                    15000,
                    (self) => {
                        execAsync("scripts/packages.sh")
                            .then((updates) => {
                                self.set_opacity(Number(updates) > 0 ? 1 : 0);
                                self.children[1].label = updates;
                            })
                            .catch(() => {
                                self.set_opacity(0);
                            });
                    },
                ],
            ],
        }),
    });

    packages.child.set_opacity(0);

    return packages;
}

export default Packages;
