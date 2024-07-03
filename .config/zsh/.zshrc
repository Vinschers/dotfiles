#!/bin/zsh

source "$HOME/.config/shell/shellrc.sh"

source "$ZDOTDIR/functions.sh"

zsh_add_file "opts.sh"
zsh_add_file "dirhistory.sh"
zsh_add_file "prompt.sh"
zsh_add_file "plugins.sh"

fpath=("$ZDOTDIR/completions" $fpath)

export HISTFILE="$XDG_STATE_HOME/zsh/history"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

function chpwd() {
    cd_venv
}

eval "$(starship init zsh)"
