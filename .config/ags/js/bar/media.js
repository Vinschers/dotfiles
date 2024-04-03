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

/**
 * @param {MprisPlayer} player
 */
const MediaText = (player) => {
    if (!player) return Widget.Box();

    const text = new Variable(
        `${player.track_artists.join(", ")} 🞄 ${player.track_title}`,
    );

    player.connect("changed", (p) => {
        text.setValue(`${p.track_artists.join(", ")} 🞄 ${p.track_title}`);
    });

    return Widget.Box({
        class_name: "media-text",
        halign: Gtk30.Align.CENTER,

        children: [
            Widget.Label({
                class_name: "media-artist",
                label: text.bind(),
                ellipsize: Pango10.EllipsizeMode.END,
            }),
        ],
    });
};

const update_colors = (image) => {
    return new Promise((resolve, reject) => {
        execAsync(
            `sh -c "convert '${image}' -colors ${COLORS_GRADIENT} -format '%c' histogram:info: | awk '{print $2}'"`,
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

const update_css = (player, colors, css) => {
    // @ts-ignore
    if (colors.length == 0) return "";

    // @ts-ignore
    const size = 100 * (colors.length + 1);
    // @ts-ignore
    const css_colors = colors.concat(colors.slice(0, 2));

    // @ts-ignore
    const background = `background-image: linear-gradient(to right, ${css_colors.join(
        ", ",
    )}); background-size: ${size}% ${size}%;`;

    const animation = "animation: gradient 12s linear infinite;";

    if (player.play_back_status === "Playing")
        css.setValue(background + animation);
    else css.setValue(background);
};

const on_player_changed = (player, css, updating) => {
    if (updating.getValue())
        return;

    updating.setValue(true);

    update_colors(player.track_cover_url)
        .then((colors) => {
            update_css(player, colors, css);
            updating.setValue(false);
        })
        .catch(console.error);
};

/**
 * @param {MprisPlayer} player
 */
const MediaBox = (player) => {
    const css = new Variable("");
    const updating = new Variable(false);

    player.connect("changed", (p) => {
        on_player_changed(p, css, updating);
    });

    on_player_changed(player, css, updating);

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
    }).hook(
        player,
        (self) => (self.visible = player.track_title !== ""),
        "closed",
    );
};

const Media = () => {
    return Widget.Box({
        spacing: 12,
        class_name: "media",
    }).bind("children", Mpris, "players", (players) => players.map(MediaBox));
};
export default Media;
