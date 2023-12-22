#!/bin/sh

lfcd() {
	tmp="$(mktemp -uq)"
	trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
	"$HOME/.config/lf/lfcd.sh" -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" || return 0
	fi
}

export lfcd
