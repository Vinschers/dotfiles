#!/bin/sh

updates_pacman=$(checkupdates | wc -l)
updates_aur=$(yay --devel -Qum 2>/dev/null | wc -l)

echo "{\"pacman\": \"$updates_pacman\", \"aur\": \"$updates_aur\"}"
