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


mksh () {
    touch "$1"
    chmod +x "$1"
    printf "#!/bin/sh\\n" > "$1"
}


export compress_tar
export compress_zip
export extract
export mksh
