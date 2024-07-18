#!/bin/sh

ffmpeg() {
    if lspci -k 2>/dev/null | grep -A 2 -E "(VGA|3D)" | grep -qi 'nvidia\|amd'; then
        /bin/ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi -hide_banner "$@"
    else
        /bin/ffmpeg -hide_banner
    fi
}

convert_video() {
    ffmpeg -i "$1" -c copy "$2"
}

embed_subtitles() {
    /bin/ffmpeg -i "$1" -vf "subtitles='${1}':si=0" -c:v libx265 -c:a copy -map 0:v -map 0:a:0 "${2:-output.mp4}"
}

export ffmpeg
export convert_video
export embed_subtitles
