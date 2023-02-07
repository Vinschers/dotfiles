#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

source_directory "$SCRIPTS_DIR"/shell/

eval "$(dircolors -b "$SCRIPTS_DIR/shell/.dir_colors")"

[ -f "$HOME/.cache/post_setup" ] || "$SCRIPTS_DIR/setup/post_setup.sh"
