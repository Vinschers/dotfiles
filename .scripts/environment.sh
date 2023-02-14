#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

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


export BASHDIR="$HOME/.config/bash"
export ZDOTDIR="$HOME/.config/zsh"

export TEXMFHOME="$XDG_CONFIG_HOME/texmf:"
#export NUGET_PACKAGES="$XDG_CONFIG_HOME/nuget"
#export CARGO_HOME="$XDG_CONFIG_HOME/cargo"
#export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
#export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm"
#export RUSTUP_HOME="$XDG_CONFIG_HOME/rustup"
#export DOTNET_CLI_HOME="$XDG_CONFIG_HOME/dotnet"
