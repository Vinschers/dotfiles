#!/bin/sh

[ -z "$1" ] && exit
img="$1"

[ -n "$2" ] && mode="$2"

python "$HOME/.config/theme/get_theme.py" "$img" "$mode"
python "$HOME/.config/theme/update.py"
