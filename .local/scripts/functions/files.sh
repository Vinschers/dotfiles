#!/bin/sh

extract () {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz)           tar xjf "$1"    ;;
            *.tar.bz2)          tar xjf "$1"    ;;
            *.tbz)              tar xjf "$1"    ;;
            *.tbz2)             tar xjf "$1"    ;;
            *.tar.gz)           tar xzf "$1"    ;;
            *.tar.xz)           tar -xf "$1"    ;;
            *.bz2)              bunzip2 "$1"    ;;
            *.rar)              unrar e "$1"    ;;
            *.gz)               gunzip "$1"     ;;
            *.tar)              tar xf "$1"     ;;
            *.tgz)              tar xzf "$1"    ;;
            *.zip)              unzip "$1"      ;;
            *.Z)                uncompress "$1" ;;
            *.7z)               7z x "$1"       ;;
            *)                  echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

compress_tar () {
    set -f
    mkdir "$1"
    cp -r "$@" "$1"
    tar czf "$1.tar.gz" "$1"
    rm -rf "$1"
}

compress_zip () {
    set -f
    mkdir "$1"
    cp -r "$@" "$1"
    zip -r "$1.zip" "$1"
    rm -rf "$1"
}


export compress_tar
export compress_zip
export extract
