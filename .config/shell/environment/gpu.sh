#!/bin/sh

if lspci -k 2>/dev/null | grep -A 3 -E "(VGA|3D)" | grep -qi amd; then
    export LIBVA_DRIVER_NAME="radeonsi"
elif lspci -k 2>/dev/null | grep -A 3 -E "(VGA|3D)" | grep -qi nvidia; then
    export LIBVA_DRIVER_NAME="nvidia"
    export GBM_BACKEND="nvidia-drm"
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export WLR_NO_HARDWARE_CURSORS=1
fi
