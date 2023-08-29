#!/bin/sh

# Update local directory
rclone copy academic: "$ACADEMIC_DIRECTORY" --exclude-from "$HOME/.config/rclone/ignore.txt"

# Update cloud directory periodically
inotifywait -m "$ACADEMIC_DIRECTORY" -e close_write -e moved_to -e move_self -e create | while read -r dir action file; do
	rclone copy "$ACADEMIC_DIRECTORY" academic: --exclude-from "$HOME/.config/rclone/ignore.txt"
done
