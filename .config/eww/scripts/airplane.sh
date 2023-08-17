#!/bin/sh

toggle() {
	if [ "$status" = "no" ]; then
		rfkill block all
		notify-send --urgency=normal -i airplane-mode-symbolic "Airplane Mode" "Airplane mode has been turned on!"
	else
		rfkill unblock all
		notify-send --urgency=normal -i airplane-mode-disabled-symbolic "Airplane Mode" "Airplane mode has been turned off!"
	fi
}

if [ "$1" = "toggle" ]; then
	toggle
else
	while true; do
		if rfkill list | grep -q 'Soft blocked: no'; then
			icon="󰀞"
            text="Off"
		else
			icon="󰀝"
            text="On"
		fi

        echo "{\"icon\": \"$icon\", \"text\": \"$text\"}"

		sleep 3
	done
fi
