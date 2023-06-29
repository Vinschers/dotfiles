#!/bin/sh

get_info() {
	info_file="$HOME/.cache/music/info.json"

    if ! [ -f "$info_file" ]; then
        echo "{}"
        return;
    fi

	status="$(jq -r '.status' "$info_file")"
	position="$(jq -r '.position' "$info_file")"
	length="$(jq -r '.length' "$info_file")"

	position_time="$(date -d@"$((position / 1000000))" +%M:%S)"

    if [ -n "$length" ]; then
	    position="$((100 * position / length))"
    else
        position="50"
    fi

	length="$(date -d@"$((length / 1000000))" +%M:%S)"

	if [ "$status" = "Playing" ]; then
		status=""
	else
		status=""
	fi

	jq -c -r \
		--arg position "$position" \
		--arg position_time "$position_time" \
		--arg length "$length" \
		--arg status "$status" \
		'. += {"position": $position, "position_time": $position_time, "length": $length, "status": $status}' "$info_file"
}

while true; do
    get_info
    sleep 0.5
done
