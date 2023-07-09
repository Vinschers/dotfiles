#!/bin/sh

get_json() {
    class=""

    if [ "$capacity" -le 25 ]; then
        class="critical"
    elif [ "$capacity" -le 50 ]; then
        class="warn"
    fi

    echo "{\"capacity\": \"$capacity\", \"status\": \"$status\", \"class\": \"$class\"}"
}

get_battery_info() {
	if [ "$(/bin/ls -A /sys/class/power_supply)" = "" ]; then
		capacity=100
		status="Charging"
		get_json
	else
		for bat in /sys/class/power_supply/BAT*; do
			capacity="$(cat "$bat/capacity")"
			status="$(cat "$bat/status")"

			get_json
		done
	fi
}

get_battery_info | jaq -sc
