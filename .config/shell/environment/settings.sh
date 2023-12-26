#!/bin/sh

export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export BROWSER="librewolf"
export TERMINAL="foot"

if lspci -k 2>/dev/null | grep -A 3 -E "(VGA|3D)" | grep -qi amd; then
    export LIBVA_DRIVER_NAME="radeonsi"
elif lspci -k 2>/dev/null | grep -A 3 -E "(VGA|3D)" | grep -qi nvidia; then
    export LIBVA_DRIVER_NAME="nvidia"
    export GBM_BACKEND="nvidia-drm"
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export WLR_NO_HARDWARE_CURSORS=1
fi

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export TEXINPUTS="$HOME/.config/texmf/templates//:"
export BIBINPUTS="$ACADEMIC_DIRECTORY/bibliography"

export GCC_COLORS='error=01;31:warning=01;93:note=01;36:caret=01;32:locus=01:quote=01'
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum"
export QT_QPA_PLATFORM="wayland"
