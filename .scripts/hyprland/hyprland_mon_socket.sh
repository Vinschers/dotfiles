#!/bin/sh

handle() {
	line="$1"
	case "$line" in
	"focusedmon"*)
		monitor="${line##*>}"
		monitor="${monitor%,*}"
		hyprctl_monitors="$(timeout 1 hyprctl monitors)"

		if [ -n "$hyprctl_monitors" ]; then
			monitor_id=$(echo "$hyprctl_monitors" | grep "$monitor" | grep -oP '(?<=ID )[0-9]+')
			echo "$monitor_id" >"/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor"
		fi
		;;
	esac
}

run_socket() {
	socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read line; do
		handle $line
	done

	notify-send "Monitor socket closed."
}

run_socket
