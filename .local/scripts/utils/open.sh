#!/bin/sh

is_video() {
	[ $(ffprobe -v quiet -select_streams v:0 -show_entries stream=codec_name -print_format csv=p=0 "$1") ]
}

is_audio() {
	! [ -z "$(file -F '//' "$1" | awk -F'//' 'tolower($2) ~ /audio/ { print "ok" }')" ]
}

is_image() {
	! [ -z "$(file -F '//' "$1" | awk -F'//' 'tolower($2) ~ /image/ { print "ok" }')" ]
}

is_pdf() {
	[ "${1##*.}" = "pdf" ]
}

! [ -f "$1" ] && exit 1


if is_image "$1"
then
	echo "Opening $1 with imv"
	imv "$1"
	exit 0
fi

if is_pdf "$1"
then
	echo "Opening $1 with zathura"
	zathura "$1"
	exit 0
fi

if is_audio "$1" || is_video "$1"
then
	echo "Playing $1 with mpv"
	mpv "$1"
	exit 0
fi

echo "Format not supported" && exit 1
