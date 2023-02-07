#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

source_directory "$SCRIPTS_DIR"/shell/

eval "$(dircolors -b "$SCRIPTS_DIR/shell/.dir_colors")"

if [ -d /opt/spotify ]; then
	sudo chmod a+wr /opt/spotify
	sudo chmod a+wr /opt/spotify/Apps -R

fi
