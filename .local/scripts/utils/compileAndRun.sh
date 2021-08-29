#!/bin/sh


runFile() {
    ! [ -f "$1" ] && return 1

    dir=$(dirname "$1")
    file=$(basename -- "$1")
    ext="${file##*.}"
    file="${file%.*}"

    case $ext in
        c)
            echo "$dir/$file"
            "$dir"/"$file" && return 0 || return 1
            ;;
        java)
            echo "java $1"
            java "$1" && return 0 || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

cr() {
    c "$1"

    runFile "$1" ||
    return 1
}

export cr