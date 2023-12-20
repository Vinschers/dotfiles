#!/bin/sh

get_keymap() {
	aux=""
    keymaps="$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap')"

	echo "$keymaps" | while read -r keyboard; do
		if [ -z "$aux" ]; then
			aux="$keyboard"
		else
			if [ "$aux" != "$keyboard" ]; then
				echo "$keyboard"
                return 0
			fi
		fi
	done

    echo "$keymaps" | head -1
}

get_keymap | cut -c1-2 | tr '[:lower:]' '[:upper:]'

socat -u "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
    layout="${line#activelayout\>\>}"
    if [ "$layout" != "$line" ]; then
        echo "${layout#*,}" | cut -c1-2 | tr '[:lower:]' '[:upper:]'
    fi
done
