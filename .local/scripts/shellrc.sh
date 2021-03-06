#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

source_directory "$SCRIPTS_DIR"/functions/
source_directory "$SCRIPTS_DIR"/shell/
