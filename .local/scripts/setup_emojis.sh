#!/bin/sh

curl "https://unicode.org/Public/emoji/14.0/emoji-test.txt" | grep -v -e '^[[:space:]]*$' | sed '/^#/d' | awk -F'#' '{print $2}' | sed -r 's/\S+//2' | awk '{sub("$", ";", $1)}; 1' > emojis
