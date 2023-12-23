#!/bin/sh

while true; do
    free | grep Mem | awk '{print $3/$2 * 100.0}'
    sleep 1
done
