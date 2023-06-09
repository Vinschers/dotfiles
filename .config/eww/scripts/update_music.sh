#!/usr/bin/env bash

get_status() {
	s=$1
	if [ "$s" = "Playing" ]; then
		echo ""
	else
		echo ""
	fi
}

get_length_sec() {
	len=$1
	if [ -z "$len" ]; then
		echo 0
	else
		bc <<< "$len / 1000000"
	fi
}

get_length_time() {
	len=$1
	if [ -n "$len" ]; then
		len=$(bc <<< "$len / 1000000 + 1")
		date -d@"$len" +%M:%S
	else
		echo ""
	fi
}

get_position() {
	pos=$1
	len=$2
	if [ -n "$pos" ]; then
		bc -l <<< "$pos / $len * 100"
	else
		echo 0
	fi
}

get_position_time() {
	pos=$1
	len=$2
	if [ -n "$pos" ]; then
		date -d@"$(bc <<< "$pos / 1000000")" +%M:%S
	else
		echo ""
	fi
}

get_cover() {
	mkdir -p "$HOME/.cache/eww_covers"
	cd "$HOME/.cache/eww_covers" || exit

	IMGPATH="$HOME/.cache/eww_covers/cover_art.png"

	COVER_URL="$1"

	if [[ "$COVER_URL" = https* ]]; then
		if [ ! -e "$HOME/.cache/eww_covers/$(basename "$COVER_URL")" ]; then
            curl -so "$HOME/.cache/eww_covers/$(basename "$COVER_URL")" "$COVER_URL"
		fi

		rm "$IMGPATH"
		ln -s "$(basename "$COVER_URL")" "$IMGPATH"

		IMG="${IMGPATH}"
	elif [ "$COVER_URL" = "" ]; then
		IMG=""
	else
		IMG="$COVER_URL"
	fi

	echo "$IMG"
}

sanitize() {
	echo "$1" | sed 's/"/\"/g'
}

prevCover=''

echo '{"title": ""}'

playerctl -p spotify -F metadata -f '{{title}}\{{artist}}\{{status}}\{{position}}\{{mpris:length}}\{{mpris:artUrl}}' 2>/dev/null | while IFS="$(printf '\')" read -r title artist status position len cover; do
	if [[ "$cover" != "$prevCover" ]]; then
		COVER=$(get_cover "$cover")

		if [ "$COVER" != "" ]; then
			cols=$(convert "$COVER" -colors 2 -format "%c" histogram:info: | awk '{print $3}')
			color1=$(echo "$cols" | head -1)
			color2=$(echo "$cols" | tail -1)
		else
			color1="#1e1e2e"
			color2="#28283d"
		fi
	fi

	json="$(jq --null-input -r -c \
		--arg artist "$(sanitize "$artist")" \
		--arg title "$(sanitize "$title")" \
		--arg status "$(get_status "$status")" \
		--arg pos "$(get_position "$position" "$len")" \
		--arg pos_time "$(get_position_time "$position" "$len")" \
		--arg length "$(get_length_time "$len")" \
		--arg cover "$COVER" \
		--arg color1 "$color1" \
		--arg color2 "$color2" \
        '{"artist": $artist, "title": $title, "status": $status, "position": $pos, "position_time": $pos_time, "length": $length, "cover": $cover, "color1": $color1, "color2": $color2}')"

    eww update music="$json"

	prevCover=$cover
done
