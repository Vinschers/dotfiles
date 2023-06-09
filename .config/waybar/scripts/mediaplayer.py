#!/usr/bin/env python3
import argparse
import datetime
import json
import logging
import signal
import subprocess
import sys

import gi

gi.require_version("Playerctl", "2.0")
from gi.repository import GLib, Playerctl

logger = logging.getLogger(__name__)


def write_output(text, player):
    logger.info("Writing output")

    output = {
        "text": text,
        "class": "custom-" + player.props.player_name,
        "alt": player.props.player_name,
        "cover": player.props.metadata["mpris:artUrl"],
    }

    sys.stdout.write(json.dumps(output) + "\n")
    sys.stdout.flush()


def get_time(milliseconds):
    dt = datetime.datetime.fromtimestamp(milliseconds / 1000000)
    return dt.strftime("%M:%S")


def update_eww(player):
    props = player.props
    meta = props.metadata

    color1, color2 = "", ""

    if meta["mpris:artUrl"] != "":
        raw_colors = (
            subprocess.run(
                ["convert", meta["mpris:artUrl"], "-colors", "2", "-format", '"%c"', "histogram:info:"],
                capture_output=True,
                text=True,
            )
            .stdout.strip("\n")
            .split("\n")
        )
        colors = []

        for raw_color in raw_colors:
            for color_part in raw_color.split():
                if color_part.startswith("#"):
                    colors.append(color_part)

        color1, color2 = colors

    info = {
        "artist": player.get_artist(),
        "title": player.get_title(),
        "status": props.status,
        "position": props.position / meta["mpris:length"] * 100,
        "position_time": get_time(props.position),
        "length": get_time(meta["mpris:length"]),
        "cover": meta["mpris:artUrl"],
        "color1": color1,
        "color2": color2
    }
    cmd = f"eww update music='{json.dumps(info)}'"

    # subprocess.run(cmd)

    sys.stdout.write(cmd + "\n")
    sys.stdout.flush()


def on_play(player, status, manager):
    logger.info("Received new playback status")
    on_metadata(player, player.props.metadata, manager)


def on_metadata(player, metadata, manager):
    logger.info("Received new metadata")
    track_info = ""

    if (
        player.props.player_name == "spotify"
        and "mpris:trackid" in metadata.keys()
        and ":ad:" in player.props.metadata["mpris:trackid"]
    ):
        track_info = "AD PLAYING"
    elif player.get_artist() != "" and player.get_title() != "":
        track_info = "{artist} - {title}".format(artist=player.get_artist(), title=player.get_title())
    else:
        track_info = player.get_title()

    if player.props.status != "Playing" and track_info:
        track_info = " " + track_info

    update_eww(player)


def on_player_appeared(manager, player, selected_player=None):
    if player is not None and (selected_player is None or player.name == selected_player):
        init_player(manager, player)
    else:
        logger.debug("New player appeared, but it's not the selected player, skipping")


def on_player_vanished(manager, player):
    logger.info("Player has vanished")


def init_player(manager, name):
    logger.debug("Initialize player: {player}".format(player=name.name))
    player = Playerctl.Player.new_from_name(name)
    player.connect("playback-status", on_play, manager)
    player.connect("metadata", on_metadata, manager)
    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager)


def signal_handler(sig, frame):
    logger.debug("Received signal to stop, exiting")
    # loop.quit()
    sys.exit(0)


def parse_arguments():
    parser = argparse.ArgumentParser()

    # Increase verbosity with every occurrence of -v
    parser.add_argument("-v", "--verbose", action="count", default=0)

    # Define for which player we're listening
    parser.add_argument("--player")

    return parser.parse_args()


def main():
    arguments = parse_arguments()

    # Initialize logging
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG, format="%(name)s %(levelname)s %(message)s")

    # Logging is set by default to WARN and higher.
    # With every occurrence of -v it's lowered by one
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))

    # Log the sent command line arguments
    logger.debug("Arguments received {}".format(vars(arguments)))

    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect("name-appeared", lambda *args: on_player_appeared(*args, arguments.player))
    manager.connect("player-vanished", on_player_vanished)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGPIPE, signal.SIG_DFL)

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.name:
            logger.debug("{player} is not the filtered player, skipping it".format(player=player.name))
            continue

        init_player(manager, player)

    loop.run()


if __name__ == "__main__":
    main()
