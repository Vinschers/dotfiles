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

const MAX_ARTISTS = 15;
const MAX_TITLE = 20;
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

const MediaText = (player) => {
    if (!player) return Widget.Box();

    return Widget.Box({
        class_name: "media-text",
        halign: Gtk30.Align.CENTER,

        children: [
            Widget.Label({
                class_name: "media-artist",
                label: player
                    .bind("track_artists")
                    .transform((artists) => artists.join(", ")),
                max_width_chars: MAX_ARTISTS,
                ellipsize: Pango10.EllipsizeMode.END,
            }),
            Widget.Label({
                class_name: "media-text-division",
                label: "🞄",
            }),
            Widget.Label({
                class_name: "media-title",
                label: player.bind("track_title"),
                max_width_chars: MAX_TITLE,
                ellipsize: Pango10.EllipsizeMode.END,
            }),
        ],
    });
};

const update_colors = (image, callback) => {
    execAsync(
        `sh -c "convert '${image}' -colors ${COLORS_GRADIENT} -format '%c' histogram:info: | awk '{print $2}'"`,
    )
        .then((output) => {
            if (!output) return;

            const alpha = 0.6;
            const colors = output.split("\n").map((color, i) => {
                const color_parts = color
                    .substring(1, color.length - 2)
                    .split(",");
                return `rgba(${color_parts[0]}, ${color_parts[1]}, ${color_parts[2]}, ${alpha})`;
            });

            callback(colors);
        })
        .catch(console.error);
};

/**
 * @param {MprisPlayer} player
 */
const MediaBox = (player) => {
    const colors = new Variable([]);

    return Widget.Box({
        class_name: "media-box",
        children: [
            MediaButtons(player),
            MediaText(player),
            Widget.Box({
                class_name: "media-background",
                css: player.bind("track_cover_url").transform((img) => {
                    update_colors(img, (new_colors) =>
                        colors.setValue(new_colors),
                    );
                    return `background-image: url('${img}');`;
                }),
            }),
        ],
        css: colors.bind().transform((colors) => {
            // @ts-ignore
            if (colors.length == 0) return "";

            // @ts-ignore
            const size = 100 * (colors.length + 1);
            // @ts-ignore
            colors = colors.concat(colors.slice(0, 2));

            // @ts-ignore
            const background = `background-image: linear-gradient(to right, ${colors.join(
                ", ",
            )}); background-size: ${size}% ${size}%;`;

            const animation = "animation: gradient 12s linear infinite;";

            if (player.play_back_status === "Playing")
                return background + animation;

            return background;
        }),
    })
        .hook(
            player,
            (self) => (self.visible = player.track_title !== ""),
            "closed",
        )
        .hook(
            Mpris,
            (_) => {
                if (player.position == -1) return;
                update_colors(player.track_cover_url, (new_colors) =>
                    colors.setValue(new_colors),
                );
            },
            "player-changed",
        );
};

const Media = () => {
    return Widget.Box({
        spacing: 12,
        class_name: "media",
    }).bind("children", Mpris, "players", (players) => players.map(MediaBox));
};
export default Media;
