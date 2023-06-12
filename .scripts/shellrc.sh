#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

eval "$(dircolors -b "$SCRIPTS_DIR/shell/.dir_colors")"

source_directory "$SCRIPTS_DIR"/shell/

if ! env | grep -q '^NVIM='; then
    neofetch
fi
