#!/bin/sh


open_nvim () {
    change_title "$TERMINAL_NAME | Neovim"
    \nvim "$@"
    change_title "$TERMINAL_NAME"
}
open_htop () {
    change_title "$TERMINAL_NAME | htop"
    \htop
    change_title "$TERMINAL_NAME"
}
open_gtop () {
    change_title "$TERMINAL_NAME | gtop"
    \gtop
    change_title "$TERMINAL_NAME"
}

export open_nvim
export open_htop
export open_gtop
