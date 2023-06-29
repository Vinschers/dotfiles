#!/bin/sh

get_info() {
	info_file="$HOME/.cache/music/info.json"

	player="$(jq -r '.player' "$info_file")"
	title="$(jq -r '.title' "$info_file")"
	artist="$(jq -r '.artist' "$info_file")"
	status="$(jq -r '.status' "$info_file")"
	position="$(jq -r '.position' "$info_file")"
	length="$(jq -r '.length' "$info_file")"

	if [ -n "$title" ]; then
		text="$artist - $title"

		if [ "$status" = "Playing" ]; then
			text=" $text"
		else
			text="󰐊 $text"
		fi
	fi

	tooltip="$(date -d@"$((1 + position / 1000000))" +%M:%S) / $(date -d@"$((length / 1000000))" +%M:%S)"

	jq -c -r -n \
		--arg text "$text" \
		--arg class "custom-$player" \
		--arg alt "$player" \
		--arg tooltip "$tooltip" \
		'{"text": $text, "class": $class, "alt": $alt, "tooltip": $tooltip}'
}

while true; do
	get_info
	sleep 0.5
done
