#!/bin/sh

printf "\033]10;#%s\007" '${fg}' >/dev/tty
printf "\033]11;#%s\007" '${bg}' >/dev/tty

printf "\033]4;%d;#%s\007" '0' '${color0}' >/dev/tty
printf "\033]4;%d;#%s\007" '1' '${color1}' >/dev/tty
printf "\033]4;%d;#%s\007" '2' '${color2}' >/dev/tty
printf "\033]4;%d;#%s\007" '3' '${color3}' >/dev/tty
printf "\033]4;%d;#%s\007" '4' '${color4}' >/dev/tty
printf "\033]4;%d;#%s\007" '5' '${color5}' >/dev/tty
printf "\033]4;%d;#%s\007" '6' '${color6}' >/dev/tty
printf "\033]4;%d;#%s\007" '7' '${color7}' >/dev/tty

printf "\033]4;%d;#%s\007" '8' '${color8}' >/dev/tty
printf "\033]4;%d;#%s\007" '9' '${color9}' >/dev/tty
printf "\033]4;%d;#%s\007" '10' '${color10}' >/dev/tty
printf "\033]4;%d;#%s\007" '11' '${color11}' >/dev/tty
printf "\033]4;%d;#%s\007" '12' '${color12}' >/dev/tty
printf "\033]4;%d;#%s\007" '13' '${color13}' >/dev/tty
printf "\033]4;%d;#%s\007" '14' '${color14}' >/dev/tty
printf "\033]4;%d;#%s\007" '15' '${color15}' >/dev/tty
