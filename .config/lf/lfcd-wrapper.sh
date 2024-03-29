#!/bin/sh

# This is a wrapper script for lf that allows it to change the directory using lfcd.sh

set -e

cleanup() {
    exec 3>&-
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	/bin/lf "$@"
else
	[ ! -d "$HOME/.cache/lf" ] && mkdir -p "$HOME/.cache/lf"
	trap cleanup HUP INT QUIT TERM PWR EXIT
	/bin/lf "$@" 3>&-
fi
