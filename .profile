#!/bin/sh

export SCRIPTS_DIR="$HOME/.scripts"

export ZDOTDIR="$HOME/.config/zsh"
export BASHDIR="$HOME/.config/bash"

if [ "${SHELL#*bash}" != "$SHELL" ]; then
	. "$BASHDIR/bashrc.sh"
fi

# python "$SCRIPTS_DIR/localhost/server.py" &
. "$SCRIPTS_DIR/environment.sh"
. "$SCRIPTS_DIR/local_environment.sh"
[ -f "$SCRIPTS_DIR/secrets/secrets.sh" ] && . "$SCRIPTS_DIR/secrets/secrets.sh"
