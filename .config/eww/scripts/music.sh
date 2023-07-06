#!/bin/sh

get_cover() {
	url="$1"
	path="$HOME/.cache/music"
	filename="$(basename "$url")"

	mkdir -p "$path"

	if ! [ -e "$path/$filename" ]; then
		/bin/rm -f "$path"/*
		curl -so "$path/$filename.png" "$url"
	fi

	echo "$path/$filename.png"
}

truncate_string() {
    str="$1"
    length="$2"

    echo "$str" | awk -v len="$length" '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }'
}

get_json() {
	jq -c -r -n \
		--arg player "$player" \
		--arg artist "$artist" \
		--arg title "$title" \
		--arg status "$status" \
		--arg position "$position" \
		--arg position_time "$position_time" \
		--arg length "$length" \
		--arg cover "$cover_img" \
		--arg color1 "$color1" \
		--arg color2 "$color2" \
		'{"player": $player, "artist": $artist, "title": $title, "status": $status, "position": $position, "position_time": $position_time, "length": $length, "cover": $cover, "color1": $color1, "color2": $color2}'
}

get_info() {
	playerctl -F metadata -f '{{title}}\{{artist}}\{{status}}\{{position}}\{{mpris:length}}\{{mpris:artUrl}}' 2>/dev/null | while IFS="$(printf "\\")" read -r title artist status position length cover; do
		if [ -n "$cover" ] && [ "$cover" != "$prevCover" ]; then
			cover_img=$(get_cover "$cover")

			if [ -n "$cover_img" ]; then
				cols=$(convert "$cover_img" -colors 2 -format "%c" histogram:info: | awk '{print $3}')
				color1=$(echo "$cols" | head -1 | awk '{print substr($0,1,7)}')
				color2=$(echo "$cols" | tail -1 | awk '{print substr($0,1,7)}')
			else
				color1="#1e1e2e"
				color2="#28283d"
			fi

			position="0"
		fi

        title="$(truncate_string "$title" 30)"
        artist="$(truncate_string "$artist" 30)"

		[ -z "$length" ] && length=$((2 * position))

		position_time="$(date -d@"$((position / 1000000))" +%M:%S)"

		if [ "$length" -gt 0 ]; then
			position="$((100 * position / length))"
		else
			position="0"
		fi

		length="$(date -d@"$((length / 1000000))" +%M:%S)"

		if [ "$status" = "Playing" ]; then
			status="󰏦"
		else
			status="󰐍"
		fi

		player="$(playerctl -l | head -1)"
		player="${player%%.*}"

		get_json

		prevCover=$cover
	done
}

get_info
