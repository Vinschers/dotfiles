#!/bin/sh

eval "$(dircolors -b "$HOME/.config/shell/.dir_colors")"

# shellcheck disable=1009
for script in "$HOME"/.config/shell/environment/*.sh; do
    # shellcheck disable=1090
    . "$script"
done

for script in "$HOME"/.config/shell/functions/*.sh; do
    # shellcheck disable=1090
    . "$script"
done

# shellcheck disable=1091
. "$HOME/.config/shell/aliases.sh"

osc7_cd() {
    cd "$1" || return $?

    tmp="$PWD"
    encoded=""
    while [ -n "$tmp" ]; do
        n="${tmp#?}"
        c="${tmp%"$n"}"
        case "$c" in
        [-/:_.!\'\(\)~[:alnum:]]) encoded="$encoded$c" ;;
        *) encoded="${encoded}$(printf '%%%02X' "'$c")" ;;
        esac
        tmp="$n"
        unset n c
    done

    printf "\033]7;file://%s%s\033\\" "$(hostname)" "$encoded"
    unset tmp encoded
}

osc7_cd "$PWD" # first-run
alias cd=osc7_cd

if ! env | grep -q '^NVIM=' && [ -z "$SHLVL" ] || [ $SHLVL -lt 2 ]; then
    fastfetch
fi
