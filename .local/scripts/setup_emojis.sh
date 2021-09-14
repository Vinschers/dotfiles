#!/bin/sh

grep -v -e '^[[:space:]]*$' emojis-raw.txt | awk -F'#' '{print $2}' | awk '{s = ""; for (i = 3; i <= NF; i++) s = s $i " "; print $1 " " s}' | sed '/subgroup/d' | sed '/subtotal/d' > emojis
