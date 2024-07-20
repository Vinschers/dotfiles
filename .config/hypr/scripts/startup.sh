#!/bin/sh

hyprpm reload -n
hyprctl dismissnotify

sleep 0.2
mainMod="SUPER"

seq 1 10 | while read -r ws; do
    i="$((ws % 10))"
    hyprctl keyword bind "$mainMod", "$i", split-workspace, "$ws"
    hyprctl keyword bind "$mainMod SHIFT", "$i", split-movetoworkspace, "$ws"
done

hyprctl keyword bind ALT SHIFT, L, split-changemonitor, next
hyprctl keyword bind ALT SHIFT, H, split-changemonitor, prev
