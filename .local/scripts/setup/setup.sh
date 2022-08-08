#!/bin/sh


check () {
    if [ "$2" = "1" ]
    then
        echo -n "$1 [Y/n] " >&2
        read ans

        [ "$ans" = "" ] || [ "$ans" = "Y" ] || [ "$ans" = "y" ]
    else
        echo -n "$1 [y/N] " >&2
        read ans

        ! [ "$ans" = "" ] || [ "$ans" = "N" ] || [ "$ans" = "n" ]
    fi
}

center() {
    termwidth="60"
    padding="$(printf '%0.1s' ={1..500})"
    txt=""
    ! [ "$1" = "" ] && txt=" $1 " && termwidth=$(( termwidth-2 ))
    printf '%*.*s%s%*.*s\n' 0 "$(((termwidth-${#1})/2))" "$padding" "$txt" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

show_menu() {
    center "Select current distro"
    echo ""
    echo -e "1.\tArch"

    echo ""
    center ""
    echo ""
    echo -n "Option: "
}


show_menu
read opt

THIS_DIRECTORY="$(dirname "$0")"
SCRIPT=""

case "$opt" in
    "1") SCRIPT="arch/arch.sh" ;;
esac

if ! [ -z "$SCRIPT" ]
then
    center "Running $SCRIPT script"
    "/bin/sh" "$THIS_DIRECTORY/$SCRIPT"
    center ""
fi

check "Set up git ssh configuration?" && "/bin/sh" "$THIS_DIRECTORY/git-ssh.sh"
check "Copy xorg.conf.d?" 1 && "/bin/sh" "$THIS_DIRECTORY/xorg.sh $THIS_DIRECTORY"
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
