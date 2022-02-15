#!/bin/sh

increase_volume () {
    pamixer -i 1 && update_dwmblocks 4
}

decrease_volume () {
    pamixer -d 1 && update_dwmblocks 4
}

export increase_volume
export decrease_volume
