#!/bin/sh

sum=0
n=0

for t in $(cat /sys/class/thermal/thermal_zone*/temp); do
    sum=$(( sum + t ))
    n=$(( n + 1 ))
done

echo "$(( sum / n ))"
