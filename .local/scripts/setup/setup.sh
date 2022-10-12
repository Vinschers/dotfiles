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

create_files_dirs () {
    sudo mkdir -p /mnt/android/
}

setup_git () {
    git config --global alias.reset-hard '!f() { git reset --hard; git clean -df ; }; f'

    echo -n "Email: "
    read email

    ssh-keygen -t ed25519 -C "$email" -N "" -f "$HOME/.ssh/id_ed25519"

    eval "$(ssh-agent -s)"

    ssh-add ~/.ssh/id_ed25519

    echo -e "Add the key in ~/.ssh/id_ed25519 to your Git account\nKey:\n\n"
    cat ~/.ssh/id_ed25519.pub
}

install_programs () {
    cd "$SCRIPTS_DIR/programs/makefile2graph" || return
    sudo make
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

check "Set up git?" && setup_git
check "Copy xorg.conf.d?" 1 && "/bin/sh" "$THIS_DIRECTORY/xorg.sh $THIS_DIRECTORY"
check "Create common files and directories?" 1 && create_files_dirs
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
