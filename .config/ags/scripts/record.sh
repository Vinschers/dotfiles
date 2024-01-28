#!/bin/sh

mkdir -p "$HOME/Videos"
cd "$HOME/Videos" || return

if [ "$(pidof wf-recorder)" = "" ]; then
	notify-send "wf-recorder" "Starting recording" -a 'wf-recorder'
	wf-recorder --audio Combined.monitor --codec h264_vaapi --audio-codec aac --file './recording_'"$(date '+%Y_%m_%_d..%H.%M')"'.mp4' --geometry "$(slurp)"
else
	/usr/bin/kill --signal SIGINT wf-recorder
	notify-send "wf-recorder" "Recording Stopped" -a 'wf-recorder'
fi
