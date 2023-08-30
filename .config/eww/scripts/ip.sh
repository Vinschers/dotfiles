#!/bin/sh

local_ipv4="$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')"
global_ipv4="$(curl -s --max-time 2 https://api.ipify.org)"
global_ipv6="$(curl -s --max-time 2 https://api6.ipify.org)"

echo "{\"local_ipv4\": \"$local_ipv4\", \"global_ipv4\": \"$global_ipv4\", \"global_ipv6\": \"$global_ipv6\"}"
