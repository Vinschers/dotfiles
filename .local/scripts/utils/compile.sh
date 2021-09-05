#!/bin/sh

compileFile() {
    ! [ -f "$1" ] && return 1

    dir=$(dirname "$1")
    file=$(basename -- "$1")
    ext="${file##*.}"
    file="${file%.*}"

    case $ext in
        c)
            echo "gcc -g -std=c99 -Wall \"$dir/$file.$ext\" -o \"$dir/$file\" -lm"
            gcc -g -std=c99 -Wall "$dir/$file.$ext" -o "$dir/$file" -lm && return 0 || return 1
            ;;
        java)
            echo "javac \"$1\""
            javac "$1" && return 0 || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

compileMake() {
    ! [ -d "$1" ] && [ -f "$1/Makefile" ] && return 1

    echo "make"
    make && return 0 || return 1
}

compileMake "$1" ||
compileFile "$1"
