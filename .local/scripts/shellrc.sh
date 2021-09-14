#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in $directory*; do source $script; done
}

source $SCRIPTS_DIR/env_variables.sh
source_directory $SCRIPTS_DIR/shell/

