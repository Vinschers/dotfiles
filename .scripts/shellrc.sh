#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

eval "$(dircolors -b "$SCRIPTS_DIR/shell/.dir_colors")"

source_directory "$SCRIPTS_DIR"/shell/

[ -f "$HOME/.cache/post_setup" ] || "$SCRIPTS_DIR/setup/post_setup.sh"
