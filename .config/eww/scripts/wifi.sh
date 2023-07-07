#!/bin/sh

toggle() {
	status=$(rfkill -J | jaq -r '.rfkilldevices[] | select(.type == "wlan") | .soft' | head -1)

	if [ "$status" = "unblocked" ]; then
		rfkill block wlan
	else
		rfkill unblock wlan
	fi
}

if [ "$1" = "toggle" ]; then
	toggle
else
	while true; do
		if cat /sys/class/net/enp*/operstate | rg -q up; then
			icon="󰈀"
			text="Ethernet"
		else
			status=$(nmcli -f state g | tail -1)
			wifistatus=$(nmcli -t -f IN-USE,SSID,SIGNAL device wifi | rg '\*')
			ssid=$(echo "$wifistatus" | awk -F: '{print $2}')
			signal=$(echo "$wifistatus" | awk -F: '{print $3}')

			text="Wifi off"

			if [ "$status" = "disconnected" ]; then
				icon="󰤩"
				class=""
			else
				level=$(awk -v n="$signal" 'BEGIN{print int((n-1)/20)}')

				if [ "$level" -lt 20 ]; then
					icon="󰤯"
				elif [ "$level" -lt 40 ]; then
					icon="󰤟"
				elif [ "$level" -lt 60 ]; then
					icon="󰤢"
				elif [ "$level" -lt 80 ]; then
					icon="󰤥"
				else
					icon="󰤨"
				fi

				class="wifi-connected"
				[ -n "$ssid" ] && text="$ssid"
			fi
		fi

		echo "{\"ssid\": \"$ssid\", \"icon\": \"$icon\", \"class\": \"$class\", \"text\": \"$text\"}"

		sleep 3
	done
fi
