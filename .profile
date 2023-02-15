#!/bin/sh

export SCRIPTS_DIR="$HOME/.scripts"

. "$SCRIPTS_DIR/shellrc.sh"

[ "$0" = "bash" ] && . "$BASHDIR/bashrc.sh"
