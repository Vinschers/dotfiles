#!/bin/sh

export ZDOTDIR="$HOME/.config/zsh"
export BASHDIR="$HOME/.config/bash"

if [ "${SHELL#*bash}" != "$SHELL" ]
then
    . "$BASHDIR/bashrc.sh"
fi

# python "$SCRIPTS_DIR/localhost/server.py" &
. "$SCRIPTS_DIR/environment.sh"
. "$SCRIPTS_DIR/shell/local_environment.sh.sh"
