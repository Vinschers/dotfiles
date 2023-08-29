#!/bin/sh

# Update local directory
rclone copy academic: "$ACADEMIC_DIRECTORY" --exclude-from "$HOME/.config/rclone/ignore.txt"

# Update cloud directory periodically
while true; do
    rclone copy "$ACADEMIC_DIRECTORY" academic: --exclude-from "$HOME/.config/rclone/ignore.txt"
    sleep 300 # Every 5 min
done
