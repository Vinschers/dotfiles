#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"

export EDITOR="nvim"
export BROWSER="librewolf"

export GCC_COLORS='error=01;31:warning=01;93:note=01;36:caret=01;32:locus=01:quote=01'

export LOCK_TIME=15

PATH="$PATH:$HOME/.local/bin:$SCRIPTS_DIR:$SCRIPTS_DIR/bin:$SCRIPTS_DIR/bin/statusbar:$SCRIPTS_DIR/hyprland:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"


load_xorg() {
    export TERMINAL="st"
    export LAUNCHER="rofi"
}

load_wayland() {
    export TERMINAL="foot"
    export LAUNCHER="wofi"
}

[ "$XDG_SESSION_TYPE" = "x11" ] && load_xorg
[ "$XDG_SESSION_TYPE" = "wayland" ] && load_wayland

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

. "$SCRIPTS_DIR/local_environment.sh"
