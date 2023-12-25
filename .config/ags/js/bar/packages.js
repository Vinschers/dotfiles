import Widget from "resource:///com/github/Aylur/ags/widget.js";

import icons from "../icons.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const updates = new Variable("0", {
    poll: [30000, `${App.configDir}/scripts/packages.sh`],
});

const Packages = () =>
    Widget.Button({
        child: Widget.Box({
            class_name: "packages",
            children: [
                Widget.Icon(icons.packages),
                Widget.Label({
                    label: updates.bind(),
                }),
            ],
            visible: updates.bind().transform((ups) => Number(ups) > 0),
        }),
    });

export default Packages;
