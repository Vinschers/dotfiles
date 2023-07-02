#!/bin/sh

extract () {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz)           tar xjf "$@"    ;;
            *.tar.bz2)          tar xjf "$@"    ;;
            *.tbz)              tar xjf "$@"    ;;
            *.tbz2)             tar xjf "$@"    ;;
            *.tar.gz)           tar xzf "$@"    ;;
            *.tar.xz)           tar -xf "$@"    ;;
            *.bz2)              bunzip2 "$@"    ;;
            *.rar)              unrar e "$@"    ;;
            *.gz)               gunzip "$@"     ;;
            *.tar)              tar xf "$@"     ;;
            *.tgz)              tar xzf "$@"    ;;
            *.zip)              unzip "$@"      ;;
            *.Z)                uncompress "$@" ;;
            *.7z)               7z x "$@"       ;;
            *)                  echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

cd "$HOME/.local/share/themes" || exit 0

[ -d "Tokyonight-Dark-B" ] || extract "Tokyonight-Dark-B.zip"
[ -d "Nordic-darker" ] || extract "Nordic-darker.tar.xz"
[ -d "Catppuccin-Mocha-B" ] || extract "Catppuccin-Mocha-B.zip"


cd "$HOME/.local/share/icons" || exit 0

[ -d "TokyoNight-SE" ] || extract "TokyoNight-SE.tar.bz2"
[ -d "Zafiro-Nord-Black" ] || extract "Zafiro-Nord-Black.tar.xz"
[ -d "Catppuccin-Mocha" ] || extract "Catppuccin-Mocha.zip"
