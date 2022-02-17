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
	center "Select installation type"
	echo ""
	echo -e "1.\tFull"
    echo -e "2.\tMinimal"
    echo -e "3.\tEssential"

	echo ""
	center ""
	echo ""
	echo -n "Option: "
}

install_packages () {
    THIS_DIRECTORY="$(dirname "$0")"

    while read -r PACKAGE
    do
        echo -e "\n\n\nInstalling $PACKAGE..."
        sudo pacman -S --noconfirm --needed "$PACKAGE"
    done < "$THIS_DIRECTORY/pacman_$1"


    while read -r PACKAGE
    do
        echo -e "\n\n\nInstalling $PACKAGE..."
        yay --noconfirm -S "$PACKAGE"
    done < "$THIS_DIRECTORY/yay_$1"

    yay -S libxft-bgra

	amixer sset Master unmute
	pulseaudio --check
	pulseaudio -D
}


show_menu
read opt

case "$opt" in
    "1") TYPE="full" ;;
    "2") TYPE="minimal" ;;
    "3") TYPE="essential" ;;
    "*") exit 1 ;;
esac


install_packages "$TYPE"
