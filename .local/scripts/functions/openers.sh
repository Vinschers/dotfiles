#!/bin/sh


open_nvim () {
    change_title "$TERMINAL | Neovim"
    \nvim "$@"
    change_title "$TERMINAL"
}
open_htop () {
    change_title "$TERMINAL | htop"
    \htop
    change_title "$TERMINAL"
}
open_gtop () {
    change_title "$TERMINAL | gtop"
    \gtop
    change_title "$TERMINAL"
}

export open_nvim
export open_htop
export open_gtop
