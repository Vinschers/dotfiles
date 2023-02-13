#!/bin/sh

export BASHDIR="$HOME/.config/bash"
export ZDOTDIR="$HOME/.config/zsh"

export EDITOR="nvim"
export BROWSER="librewolf"

export GCC_COLORS='error=01;31:warning=01;93:note=01;36:caret=01;32:locus=01:quote=01'

export LOCK_TIME=15

export TEXMFHOME="$HOME/.config/texmf:"

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
