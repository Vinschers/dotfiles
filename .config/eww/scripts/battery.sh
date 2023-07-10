#!/bin/sh

get_json() {
    class=""

    if [ "$capacity" -le 25 ]; then
        class="critical"
    elif [ "$capacity" -le 50 ]; then
        class="warn"
    else
        class="ok"
    fi

    if [ "$capacity" -le 10 ]; then
        icon="󰁺"
        [ "$status" = "Charging" ] && icon="󰢜"
    elif [ "$capacity" -le 20 ]; then
        icon="󰁻"
        [ "$status" = "Charging" ] && icon="󰂆"
    elif [ "$capacity" -le 30 ]; then
        icon="󰁼"
        [ "$status" = "Charging" ] && icon="󰂇"
    elif [ "$capacity" -le 40 ]; then
        icon="󰁽"
        [ "$status" = "Charging" ] && icon="󰂈"
    elif [ "$capacity" -le 50 ]; then
        icon="󰁾"
        [ "$status" = "Charging" ] && icon="󰢝"
    elif [ "$capacity" -le 60 ]; then
        icon="󰁿"
        [ "$status" = "Charging" ] && icon="󰂉"
    elif [ "$capacity" -le 70 ]; then
        icon="󰂀"
        [ "$status" = "Charging" ] && icon="󰢞"
    elif [ "$capacity" -le 80 ]; then
        icon="󰂁"
        [ "$status" = "Charging" ] && icon="󰂊"
    elif [ "$capacity" -le 90 ]; then
        icon="󰂂"
        [ "$status" = "Charging" ] && icon="󰂋"
    elif [ "$capacity" -le 100 ]; then
        icon="󰁹"
        [ "$status" = "Charging" ] && icon="󰂅"
    fi

    echo "{\"capacity\": \"$capacity\", \"status\": \"$status\", \"class\": \"$class\", \"icon\": \"$icon\"}"
}

get_battery_info() {
	if [ "$(/bin/ls -A /sys/class/power_supply)" = "" ]; then
		capacity=100
		status="Chargin"
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
