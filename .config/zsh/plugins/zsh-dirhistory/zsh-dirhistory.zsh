#!/bin/sh


zle_nav_dir_left () {
    zle .kill-buffer
    nav_dir_left
    zle .accept-line
}
zle -N zle_nav_dir_left

zle_nav_dir_up () {
    zle .kill-buffer
    nav_dir_up
    zle .accept-line
}
zle -N zle_nav_dir_up

zle_nav_dir_down () {
    zle .kill-buffer
    nav_dir_down
    zle .accept-line
}
zle -N zle_nav_dir_down

zle_nav_dir_right () {
    zle .kill-buffer
    nav_dir_right
    zle .accept-line
}
zle -N zle_nav_dir_right

bindkey '\e^h' zle_nav_dir_left
bindkey '\e^j' zle_nav_dir_down
bindkey '\e^k' zle_nav_dir_up
bindkey '\e^l' zle_nav_dir_right
