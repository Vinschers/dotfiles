#!/bin/sh


nav_dir_left () {
    dir="$(\ls -1A .. | awk -v dir="${PWD##*/}" 'prev { if ($1 == dir) print prev } { prev = $0 }')"
    [ -z "$dir" ] && dir="$(\ls -1A | tail -1)"
    if [ -d "../$dir" ]
    then
        cd "../$dir" || return 1
    else
        cd "$(\ls -1Ad ../*/ | tail -1)" || return 1
    fi
}

nav_dir_down () {
    cd "$(\ls -1A | head -1)" || return 1
}

nav_dir_up () {
    cd .. || return 1
}

nav_dir_right () {
    dir="$(\ls -1A .. | awk -v dir=${PWD##*/} 'f { print; f = 0 } { if ($1 == dir) f = 1 }')"
    [ -z "$dir" ] && dir="$(\ls -1A | head -1)"
    if [ -d "../$dir" ]
    then
        cd "../$dir" || return 1
    else
        cd "../$(\ls -1A .. | head -1)" || return 1
    fi
}

export nav_dir_left
export nav_dir_down
export nav_dir_up
export nav_dir_right
