#!/bin/sh

export ZDOTDIR="$HOME/.config/zsh"
export BASHDIR="$HOME/.config/bash"

if [ "${SHELL#*bash}" != "$SHELL" ]
then
	. "$HOME/.bashrc"
fi

python "$SCRIPTS_DIR/localhost/server.py" &
startx
