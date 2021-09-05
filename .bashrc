#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Autocomplete using sudo
complete -cf sudo
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

source ~/.local/scripts/shellrc.sh
