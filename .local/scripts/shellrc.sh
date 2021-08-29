#!/bin/sh

source_directory() {
	directory=$1

	[ "$directory" = "*/" ] || directory="$directory/"

	for script in $directory*; do source $script; done
}

source_directory ~/.scripts/shell/
source_directory ~/.scripts/utils/
