#!/bin/sh


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
	"1") SCRIPT="arch.sh" ;;
	"*") exit 1 ;;
esac

center "Running $SCRIPT script"
"/bin/sh" "$THIS_DIRECTORY/$SCRIPT" || exit 1
center ""

center "Setting up git ssh configurations"
"/bin/sh" "$THIS_DIRECTORY/git-ssh.sh" || exit 1
center ""
