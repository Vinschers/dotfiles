import Widget from "resource:///com/github/Aylur/ags/widget.js";

export const searchItem = ({
    materialIconName,
    name,
    actionName,
    content,
    onActivate,
}) => {
    const actionText = Widget.Revealer({
        reveal_child: false,
        transition: "crossfade",
        transition_duration: 200,
        child: Widget.Label({
            class_name: "overview-search-results-txt",
            label: `${actionName}`,
        }),
    });
    const actionTextRevealer = Widget.Revealer({
        reveal_child: false,
        transition: "slide_left",
        transition_duration: 300,
        child: actionText,
    });
    return Widget.Button({
        class_name: "overview-search-result-btn",
        on_clicked: onActivate,
        child: Widget.Box({
            children: [
                Widget.Box({
                    vertical: false,
                    children: [
                        Widget.Icon({
                            class_name: `overview-search-results-icon`,
                            icon: materialIconName,
                        }),
                        Widget.Box({
                            vertical: true,
                            children: [
                                Widget.Label({
                                    hpack: "start",
                                    class_name:
                                        "overview-search-results-txt-name",
                                    label: `${name}`,
                                    truncate: "end",
                                }),
                                Widget.Label({
                                    hpack: "start",
                                    class_name:
                                        "overview-search-results-txt",
                                    label: `${content}`,
                                    truncate: "end",
                                }),
                            ],
                        }),
                        Widget.Box({ hexpand: true }),
                        actionTextRevealer,
                    ],
                }),
            ],
        }),
        setup: (self) =>
            self
                .on("focus-in-event", (button) => {
                    actionText.reveal_child = true;
                    actionTextRevealer.reveal_child = true;
                })
                .on("focus-out-event", (button) => {
                    actionText.reveal_child = false;
                    actionTextRevealer.reveal_child = false;
                }),
    });
};
