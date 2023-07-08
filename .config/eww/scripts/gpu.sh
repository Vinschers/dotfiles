#!/bin/sh

if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi nvidia; then
    command -v "nvidia-smi" >/dev/null 2>&1 || exit
    nvidia-smi -q -d UTILIZATION | awk -F: '/Avg/ {print $2}' | grep -Po '[0-9]+' -m 1
elif lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi amd; then
    echo 20
fi
