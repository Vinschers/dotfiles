#!/bin/sh

export SCRIPTS_DIR="$HOME/.scripts"

. "$HOME/.config/shell/shellrc.sh"

if [ "$0" = "bash" ]; then
    . "$BASHDIR/bashrc.sh"
fi
