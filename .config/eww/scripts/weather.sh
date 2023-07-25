#!/bin/sh

icon="$(curl --silent --max-time 2 'wttr.in?format=%c' | sed 's/ //g')"
json="$(curl --silent --max-time 2 'wttr.in?format=j1' | jq -c '{temp: .current_condition[0].temp_C, feels: .current_condition[0].FeelsLikeC, location: .nearest_area[0].areaName[0].value, desc: .current_condition[0].weatherDesc[0].value}')"

echo "$json" | jq -rc ". += {icon: \"$icon\"}"
