#!/bin/sh

yazi() {
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	/bin/yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd" || exit
	fi
	rm -f -- "$tmp"
}

export yazi
