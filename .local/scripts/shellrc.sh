#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in "$directory"*; do . "$script"; done
}

. "$SCRIPTS_DIR"/shell/env_variables.sh
source_directory "$SCRIPTS_DIR"/shell/
