#!/bin/zsh

source "$HOME/.config/shell/shellrc.sh"

source "$ZDOTDIR/functions.sh"

zsh_add_file "opts.sh"
zsh_add_file "dirhistory.sh"
zsh_add_file "prompt.sh"
zsh_add_file "plugins.sh"

fpath=("$ZDOTDIR/completions" $fpath)

# Change directory with lf
function osc7 {
    local LC_ALL=C
    export LC_ALL

    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7

export HISTFILE="$XDG_STATE_HOME/zsh/history"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

eval "$(starship init zsh)"
