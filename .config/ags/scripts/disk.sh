#!/bin/sh

while true; do
    df "$HOME" | awk '{print $5}' | tail -1 | sed 's/%//g'
    sleep 1
done
