#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source "$BASHDIR"/ps1.sh
source "$BASHDIR"/shopt.sh

# Autocomplete using sudo
complete -cf sudo
# [ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

export HISTFILE="$XDG_CONFIG_HOME/.bash_history"
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash-completion/bash_completion"
