#!/bin/sh

while true; do
    sensors -A | grep Core | awk '{sum+=$3} END {print sum/NR}'
    sleep 1
done
