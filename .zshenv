#!/bin/zsh

export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export BROWSER="librewolf"
export TERMINAL="foot"

if lspci -k | grep -A 3 -E "(VGA|3D)" | grep -qi amd; then
    export LIBVA_DRIVER_NAME="radeonsi"
elif lspci -k | grep -A 3 -E "(VGA|3D)" | grep -qi nvidia; then
    export LIBVA_DRIVER_NAME="nvidia"
    export GBM_BACKEND="nvidia-drm"
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export WLR_NO_HARDWARE_CURSORS=1
fi
