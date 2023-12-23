#!/bin/sh

while true; do
    top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'
    sleep 1
done
