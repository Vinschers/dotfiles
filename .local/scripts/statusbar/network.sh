#!/bin/sh

logfile="${XDG_CACHE_HOME:-$HOME/.cache}/netlog"
read rxprev txprev < "$logfile"

rxcurrent="$(($(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+')))"
txcurrent="$(($(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+')))"

rx=rxcurrent-rxprev
tx=txcurrent-txprev

printf "🔻%sMbps 🔺%sMbps\\n" \
        "$(( 8*(rx)/(1024*1024) ))" \
        "$(( 8*(tx)/(1024*1024) ))"

echo "$rxcurrent $txcurrent" > "$logfile"
