#!/bin/sh

ffmpeg() {
    if lspci -k 2>/dev/null | grep -A 2 -E "(VGA|3D)" | grep -qi 'nvidia\|amd'; then
        /bin/ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi -hide_banner "$@"
    else
        /binffmpeg -hide_banner
    fi
}

convert_video() {
    ffmpeg -i "$1" -c copy "$2"
}

export ffmpeg
export convert_video
