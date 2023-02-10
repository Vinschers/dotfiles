#!/bin/sh

handle() {
	line="$1"
	case "$line" in
	"focusedmon"*)
		monitor="${line##*>}"
		monitor="${monitor%,*}"
		monitor_id=$(hyprctl monitors | grep "$monitor" | grep -oP '(?<=ID )[0-9]+')
		echo "$monitor_id" >"/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/active_monitor"
		;;
	esac
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read line; do handle $line; done
