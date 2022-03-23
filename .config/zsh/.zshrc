#!/bin/zsh

source "$ZDOTDIR/functions.sh"

zsh_add_file "opts.sh"
zsh_add_file "dirhistory.sh"
zsh_add_file "prompt.sh"
zsh_add_file "plugins.sh"

fpath=("$ZDOTDIR/completions" $fpath)

source "$SCRIPTS_DIR"/shellrc.sh
