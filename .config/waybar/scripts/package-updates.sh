#!/bin/sh

format() {
	if [ "$1" -eq 0 ]; then
		echo '-'
	else
		echo "$1"
	fi
}

while
	updates_pacman=$(checkupdates 2>/dev/null)
	[ $? -eq 1 ]
do true; done

updates_pacman=$(printf "%s" "$updates_pacman" | wc -l)
updates_aur=$(yay -Qum 2>/dev/null | wc -l)
updates=$(( updates_pacman + updates_aur))

[ "$updates" -gt 0 ] && echo "  $(format "$updates_pacman")/$(format "$updates_aur")"
