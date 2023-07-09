#!/bin/sh

get_icon() {
	brightness="$1"

    echo "󰃟"
}

get_json() {
	echo "{\"icon\": \"$icon\", \"value\": \"$brightness\"}"
}

if [ "$1" = "set" ]; then
	brightness="$2"

	[ -z "$brightness" ] && exit 0

    light "$brightness" 2>/dev/null
	icon="$(get_icon "$brightness")"

	eww update bright="$(get_json)"
elif [ -z "$1" ]; then
	while true; do
		brightness="$(light 2>/dev/null)"
		icon="$(get_icon "$brightness")"

		get_json

		sleep 3
	done
fi
