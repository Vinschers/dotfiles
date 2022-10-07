#!/bin/sh

[ -n "$(xsetwacom list devices)" ] && "$SCRIPTS_DIR/devices/wacom.sh"

#python "$SCRIPTS_DIR/external/inkscape-shortcut-manager/main.py" &

sxhkd
