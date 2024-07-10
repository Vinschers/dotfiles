import Widget, {
    CircularProgress,
} from "resource:///com/github/Aylur/ags/widget.js";
import Mpris, {
    MprisPlayer,
} from "resource:///com/github/Aylur/ags/service/mpris.js";
import Gtk30 from "gi://Gtk?version=3.0";
import Pango10 from "gi://Pango";
import icons from "../icons.js";
import { execAsync } from "resource:///com/github/Aylur/ags/utils.js";
import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

const COLORS_GRADIENT = 3;

const TrackProgress = (player) => {
    if (!player) return CircularProgress();

    const updateProgress = (circprog) => {
        if (!player) return;

        circprog.value = player.position / player.length;

        let icon = icons.mpris.stopped;

        if (player.play_back_status === "Playing") icon = icons.mpris.playing;
        else if (player.play_back_status === "Paused")
            icon = icons.mpris.paused;

        if (circprog.child) circprog.child.icon = icon;
    };

    return Widget.Button({
        on_primary_click: () => {
            if (player) player.playPause();
        },
        child: CircularProgress({
            class_name: "circprog",
            start_at: 0.75,
            child: Widget.Icon(),
        })
            .hook(Mpris, updateProgress)
            .hook(player, updateProgress, "position")
            .poll(3000, updateProgress),
    });
};

const MediaButtons = (player) => {
    if (!player) return Widget.Box();

    return Widget.CenterBox({
        class_name: "media-buttons",
        spacing: 12,

        start_widget: Widget.Button({
            child: Widget.Icon(icons.mpris.prev),
            on_primary_click: () => {
                if (player.can_go_prev) player.previous();
            },
        }),
        center_widget: TrackProgress(player),
        end_widget: Widget.Button({
            child: Widget.Icon(icons.mpris.next),
            on_primary_click: () => {
                if (player.can_go_next) player.next();
            },
        }),
    });
};

const get_player_info = (track_artists, track_album) => {
    if (track_artists.length == 0 || track_artists[0].length == 0) {
        if (track_album === "") return "";
        return track_album;
    }

    let info = track_artists.join(", ");
    if (track_album !== "") info += " 🞄 " + track_album;
    return info;
};

/**
 * @param {MprisPlayer} player
 */
const MediaText = (player) => {
    if (!player) return Widget.Box();

    const pinfo = new Variable(
        get_player_info(player.track_artists, player.track_album),
    );

    player.connect("changed", (p) => {
        pinfo.setValue(get_player_info(p.track_artists, p.track_album));
    });

    return Widget.Box({
        class_name: "media-text",
        vertical: true,
        vpack: "center",

        children: [
            Widget.Label({
                class_name: "media-title",
                label: player.bind("track_title"),
                ellipsize: Pango10.EllipsizeMode.END,
            }),
            Widget.Label({
                class_name: "media-artist",
                hpack: "start",
                label: pinfo.bind(),
                ellipsize: Pango10.EllipsizeMode.END,
                visible: pinfo.bind().as((info) => info.length > 0),
            }),
        ],
    });
};

const update_colors = (image_url) => {
    return new Promise((resolve, reject) => {
        execAsync(
            `sh -c "convert '${image_url}' -colors ${COLORS_GRADIENT} -format '%c' histogram:info: | awk '{print $2}'"`,
        )
            .then((output) => {
                if (!output) return;

                const alpha = 0.6;
                const colors = output.split("\n").map((color) => {
                    const color_parts = color
                        .substring(1, color.length - 2)
                        .split(",");
                    return `rgba(${color_parts[0]}, ${color_parts[1]}, ${color_parts[2]}, ${alpha})`;
                });

                resolve(colors);
            })
            .catch(reject);
    });
};

const update_css = (player_status, colors) => {
    // @ts-ignore
    if (colors.length == 0) return "";

    // @ts-ignore
    const size = 100 * (colors.length + 1);
    // @ts-ignore
    const css_colors = colors.concat(colors.slice(0, 2));

    // @ts-ignore
    const background = `background-image: linear-gradient(to right, ${css_colors.join(
        ", ",
    )}); background-size: ${size}% ${size}%; animation: gradient 12s linear infinite;`;

    if (player_status === "Playing") {
        return background + "animation-play-state: running;";
    } else {
        return background + "animation-play-state: paused;";
    }
};

/**
 * @param {MprisPlayer} player
 */
const MediaBox = (player) => {
    const css = new Variable("");
    const image_url = new Variable("");
    const colors = new Variable([]);

    return Widget.Box({
        class_name: "media-box",
        children: [
            Widget.Box({
                class_name: "media-background",
                css: player.bind("track_cover_url").transform((img) => {
                    return `background-image: url('${img}');`;
                }),
            }),
            MediaText(player),
            MediaButtons(player),
        ],
        css: css.bind(),
    })
        .hook(
            player,
            (self) => (self.visible = player.track_title !== ""),
            "closed",
        )
        .hook(
            player,
            () => {
                if (image_url.getValue() !== player.track_cover_url) {
                    image_url.setValue(player.track_cover_url);

                    update_colors(image_url.getValue())
                        .then((new_colors) => {
                            colors.setValue(new_colors);
                            css.setValue(
                                update_css(
                                    player.play_back_status,
                                    colors.getValue(),
                                ),
                            );
                        })
                        .catch(console.error);
                } else {
                    css.setValue(
                        update_css(player.play_back_status, colors.getValue()),
                    );
                }
            },
            "changed",
        );
};

const Media = () => {
    return Widget.Box({
        spacing: 12,
        class_name: "media",
    }).bind("children", Mpris, "players", (players) => players.map(MediaBox));
};
export default Media;
