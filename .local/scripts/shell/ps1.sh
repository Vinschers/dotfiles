#!/bin/sh


PS1_STYLE=2


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

get_color() {
	echo "\[\033[$1;$2;$3m\]"
}

write_with_color() {
	echo "$2$1$CLEAR"
}

get_git_info() {
	git_info_open=$(write_with_color "(" "$GIT_TEXT_COLOR")

	git_branch=$(write_with_color "$BRANCH" "$GIT_BRANCH_COLOR")

	git_info_close=$(write_with_color ")" "$GIT_TEXT_COLOR")

	git_info="$git_info_open$git_branch$git_info_close"
	echo "$git_info"
}

set_style_0() {
	USR_COLOR=$BOLD$(get_color 38 5 229)
	PC_COLOR=$BOLD$(get_color 38 5 3)
	PC_PATH_COLOR=$(get_color 38 5 10)
	DIR_COLOR=$BOLD$(get_color 38 5 41)

	GIT_TEXT_COLOR=$(get_color 38 5 75)
	GIT_BRANCH_COLOR=$(get_color 38 5 208)

	VENV_COLOR=$(get_color 38 5 9)
}

set_style_1() {
	USR_COLOR=$BOLD$(get_color 38 5 41)
	PC_COLOR=$BOLD$(get_color 38 5 10)
	PC_PATH_COLOR=$(get_color 38 5 98)
	DIR_COLOR=$BOLD$(get_color 38 5 99)

	GIT_TEXT_COLOR=$(get_color 38 5 75)
	GIT_BRANCH_COLOR=$(get_color 38 5 81)

	VENV_COLOR=$(get_color 38 5 9)
}

set_style_2() {
	USR_COLOR=$BOLD$(get_color 38 5 41)
	PC_COLOR=$BOLD$(get_color 38 5 33)
	PC_PATH_COLOR=$(get_color 38 5 39)
	DIR_COLOR=$BOLD$(get_color 38 5 45)

	GIT_TEXT_COLOR=$(get_color 38 5 135)
	GIT_BRANCH_COLOR=$(get_color 38 5 99)

	CONSOLE_COLOR=$BOLD$(get_color 38 5 43)

	VENV_COLOR=$(get_color 38 5 9)
}

set_style() {
	case $1 in
		0) 	set_style_0;;
		1)	set_style_1;;
		2)	set_style_2;;
	esac
}

set_ps1() {
	RET=$?
	[ $RET = "0" ] && PS1_STYLE=2 || PS1_STYLE=0

	BOLD="\[$(tput bold)\]"
	CLEAR="\[$(tput sgr0)\]"
	BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

	set_style "$PS1_STYLE"

	open_path=$(write_with_color "[" "$PC_COLOR")
	
	user=$(write_with_color "\u" "$USR_COLOR")
	behind=$(write_with_color "$(get_behind_path)" "$PC_PATH_COLOR")
	current_dir=$(write_with_color "$(format_dir "$PWD")" "$DIR_COLOR")
	path="$behind$current_dir"
	close_path=$(write_with_color "]" "$PC_COLOR")

	[ "$BRANCH" ] && git_info="$(get_git_info) " || git_info=""
	[ "$VIRTUAL_ENV" ] && venv_info="$(write_with_color "<$(basename "$VIRTUAL_ENV")>" "$VENV_COLOR") " || venv_info=""

	path_info="$open_path $user $path $git_info$close_path"
	console=$(write_with_color "\$" "$CONSOLE_COLOR")

	export PS1="$venv_info$path_info$console "
}

export PROMPT_COMMAND=set_ps1
