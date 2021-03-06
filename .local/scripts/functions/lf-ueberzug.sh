#!/bin/sh


lf-ueberzug() {
	cleanup() {
		lf-ueberzug-cleaner
		kill "$UEBERZUGPID"
		pkill -f "tail -f $LF_UEBERZUG_TEMPDIR/fifo"
		rm -rf "$LF_UEBERZUG_TEMPDIR"
	}
	trap cleanup INT HUP

	# Set up temporary directory.
	export LF_UEBERZUG_TEMPDIR="$(mktemp -d -t lf-ueberzug-XXXXXX)"

	# Launch ueberzug.
	mkfifo "$LF_UEBERZUG_TEMPDIR/fifo"
	tail -f "$LF_UEBERZUG_TEMPDIR/fifo" | ueberzug layer --silent &
	UEBERZUGPID=$!

	lf "$@"
	cleanup
    trap - INT HUP
}
