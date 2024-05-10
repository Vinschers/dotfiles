#!/bin/sh

monitor_added() {
	ags -q

	monitor_id="$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$1\") | .id")"
	active_monitor="$(hyprctl activeworkspace -j | jq -r '.monitorID')"

	hyprctl dispatch focusmonitor "$monitor_id"
	hyprsome workspace 1

	hyprctl dispatch focusmonitor "$active_monitor"

	hyprctl dispatch exec ags
}

monitor_removed() {
	monitor="$1"

	hyprctl workspaces -j | jq -r ".[] | select(.monitor == \"$monitor\") | .id" | while read -r id; do

		hyprctl clients -j | jq -r ".[] | select(.workspace.id == \"$id\" | .address)" | while read -r address; do
			window="address:$address"

			hyprctl dispatch focuswindow "$window"
			hyprctl dispatch movewindow mon:-1
		done
	done

	hyprctl dispatch focusmonitor -1
}

handle() {
	if [ "${1#*monitoradded>>}" != "$1" ]; then
		monitor_added "${1#*monitoradded>>}"
	elif [ "${1#*monitorremoved>>}" != "$1" ]; then
		monitor_removed "${1#*monitorremoved>>}"
	fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
