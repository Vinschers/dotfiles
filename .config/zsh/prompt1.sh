#!/bin/sh

BRACKET_COLOR=33
PATH_COLOR=39
CURRENT_DIR_COLOR=45
USER_COLOR=41
CONSOLE_COLOR=43

# azul - 33
# verde - 41
# azul claro - 39
# azul claro forte - 45
# git - 135
# branch - 99
# console - 43
# venv - 9


get_behind_path() {
	currentdir="$PWD"
	parentdir=$(format_dir "$(dirname "$PWD")")
	grandpadir=$(format_dir "$(dirname "$(dirname "$PWD")")")
	greatpadir=$(format_dir "$(dirname "$(dirname "$(dirname "$PWD")")")")

	[ "$currentdir" = "/home/$USER" ] || [ "$currentdir" = "/" ] || [ "$parentdir" = "/" ] && return

	[ "$parentdir" = "~" ] || [ "$grandpadir" = "/" ] && echo "$parentdir" && return

	[ "$grandpadir" = "~" ] || [ "$greatpadir" = "/" ] && echo "$grandpadir$parentdir" && return

	[ "$greatpadir" = "~" ] && echo "~$grandpadir$parentdir" && return

	echo "/...$grandpadir$parentdir"
}

format_dir() {
	[ "$1" = "/home/$USER" ] && echo "~" && return
	[ "$1" = "/" ] && echo "$1" && return

	echo "/$(basename "$1")"
}

get_user () {
    echo "%B%F{121}%n%b%F{34}@%F{121}%m"
}

get_path () {
    echo "%F{45}$(get_behind_path)%B%F{117}$(format_dir "$PWD")%b"
}

get_git () {
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

    [ "$BRANCH" ] && echo " %F{135}[%F{141} $BRANCH%b%F{135}]" || echo ""
}

get_user_path_git () {
    echo "$(get_user)%B%F{228}  %b$(get_path)$(get_git)%b"
}

get_console_cursor () {
    echo "%F{231}\$"
}

reset_colors () {
    echo "%F{015}%b"
}

precmd () {
    export PROMPT="$(get_user_path_git) $(get_console_cursor) $(reset_colors)"
}
