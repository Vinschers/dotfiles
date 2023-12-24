import Widget, {
    CircularProgress,
} from "resource:///com/github/Aylur/ags/widget.js";
import Mpris, {
    MprisPlayer,
} from "resource:///com/github/Aylur/ags/service/mpris.js";
import Gtk30 from "gi://Gtk?version=3.0";
import Pango10 from "gi://Pango";
import icons from "../icons.js";

const MAX_ARTISTS = 20;
const MAX_TITLE = 40;

const TrackProgress = (player) => {
    if (!player) return CircularProgress();

    const _updateProgress = (circprog) => {
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
            connections: [
                // Update on change/once every 3 seconds
                [Mpris, _updateProgress],
                [1000, _updateProgress],
            ],
        }),
    });
};

const MediaButtons = (player) => {
    if (!player) return Widget.Box();

    return Widget.CenterBox({
        class_name: "media-buttons",
        spacing: 8,

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

    const artists = player.track_artists.join(", ");
    const title = player.track_title;

    return Widget.Box({
        class_name: "media-text",
        halign: Gtk30.Align.CENTER,

        children: [
            Widget.Label({
                class_name: "media-artist",
                label: artists,
                max_width_chars: MAX_ARTISTS,
                ellipsize: Pango10.EllipsizeMode.END,
            }),
            Widget.Label({
                class_name: "media-text-division",
                label: "🞄",
            }),
            Widget.Label({
                class_name: "media-title",
                label: title,
                max_width_chars: MAX_TITLE,
                ellipsize: Pango10.EllipsizeMode.END,
            }),
        ],
    });
};

const MediaBackground = (player) => {
    if (!player) return Widget.Box();

    return Widget.Box({
        class_name: "media-background",
        css: `background-image: url('${player.track_cover_url}'); ${
            player.play_back_status === "Playing"
                ? "animation: 60s linear infinite up-down;"
                : ""
        }`,
    });
};

/**
 * @param {MprisPlayer} player
 */
const MediaBox = (player) => {
    if (!player) return Widget.Box();

    return Widget.Overlay({
        class_name: "media-box",
        child: MediaBackground(player),
        overlays: [
            Widget.Box({
                children: [MediaButtons(player), MediaText(player)],
            }),
        ],
        pass_through: true,
    });
};

const Media = () => {
    let prev_player = Mpris.getPlayer("");

    const update_mpris = (media) => {
        const player =
            Mpris.players.find((p) => p.play_back_status == "Playing") ||
            prev_player;
        if (!player) return;

        prev_player = player;
        media.children = [MediaBox(player)];
    };

    return Widget.Box({
        class_name: "media",
        connections: [[Mpris, update_mpris]],
    });
};
export default Media;
