#!/bin/sh

export SCRIPTS_DIR="$HOME/.scripts"

export ZDOTDIR="$HOME/.config/zsh"
export BASHDIR="$HOME/.config/bash"

if [ "${SHELL#*bash}" != "$SHELL" ]; then
	. "$BASHDIR/bashrc.sh"
fi

# python "$SCRIPTS_DIR/localhost/server.py" &
. "$SCRIPTS_DIR/environment.sh"
. "$SCRIPTS_DIR/local_environment.sh"
[ -f "$SCRIPTS_DIR/secrets/secrets.sh" ] && . "$SCRIPTS_DIR/secrets/secrets.sh"

create_symlink() {
	[ -f "$2" ] || ln -s "$1" "$2"
}

create_file() {
	[ -f "$1" ] || echo "$2" >"$1"
}

create_symlink "$HOME/.config/Xresources" "$HOME/.Xresources"
create_symlink "$HOME/.profile" "$HOME/.zprofile"
create_symlink "$HOME/.config/librewolf" "$HOME/.librewolf"

create_file "$HOME/.cache/cpustatus" "0"
create_file "$HOME/.cache/datetime" "0"
create_file "$HOME/.cache/diskspace" "0 1000"
create_file "$HOME/.cache/hardware" "0"
create_file "$HOME/.cache/weather" "0"
