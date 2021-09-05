#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in $directory*; do source $script; done
}

source_directory ~/.local/scripts/shell/
