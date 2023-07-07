#!/bin/sh

get_icon() {
	vol="$1"

	if [ "$(pamixer --get-mute)" = "true" ]; then
		echo "󰸈"
	else
		if [ "$vol" -eq 0 ]; then
			echo "󰕿"
		elif [ "$vol" -lt 20 ]; then
			echo "󰖀"
		elif [ "$vol" -lt 50 ]; then
			echo "󰕾"
		else
			echo ""
		fi
	fi
}

get_json() {
	echo "{\"icon\": \"$icon\", \"value\": \"$volume\"}"
}

if [ "$1" = "toggle" ]; then
	pamixer -t

    volume="$(pamixer --get-volume)"
    icon="$(get_icon "$volume")"

	eww update volume="$(get_json)"
elif [ "$1" = "set" ]; then
	volume="$2"

	[ -z "$volume" ] && exit 0

	pamixer --set-volume "$volume"
	icon="$(get_icon "$volume")"

	eww update volume="$(get_json)"
elif [ -z "$1" ]; then
	while true; do
		volume="$(pamixer --get-volume)"
		icon="$(get_icon "$volume")"

		get_json

		sleep 3
	done
fi
