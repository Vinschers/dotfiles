#!/bin/sh


check () {
    if [ "$2" = "1" ]
    then
        printf "%s [Y/n] " "$1" >&2
        read -r ans

        [ "$ans" = "" ] || [ "$ans" = "Y" ] || [ "$ans" = "y" ]
    else
        printf "%s [y/N] " "$1" >&2
        read -r ans

        ! [ "$ans" = "" ] || [ "$ans" = "N" ] || [ "$ans" = "n" ]
    fi
}

create_files_dirs () {
    sudo mkdir -p /mnt/android/
    mkdir "$HOME/Downloads"
}

setup_git () {
    git config --global alias.reset-hard '!f() { git reset --hard; git clean -df ; }; f'

    printf "Email: "
    read -r email

    ssh-keygen -t ed25519 -C "$email" -N "" -f "$HOME/.ssh/id_ed25519"

    eval "$(ssh-agent -s)"

    ssh-add ~/.ssh/id_ed25519

    printf "Add the key in ~/.ssh/id_ed25519 to your Git account\nKey:\n\n"
    cat ~/.ssh/id_ed25519.pub
}

install_programs () {
    cd "$SCRIPTS_DIR/programs/makefile2graph" || return
    sudo make
}

ignore_local_files () {
    cd "$SCRIPTS_DIR/shell" || return
    dotfiles update-index --assume-unchanged local_environment.sh

    cd "$HOME/.cache" || return
    dotfiles update-index --assume-unchanged cpustatus datetime diskspace hardware weather
}


THIS_DIRECTORY="$(dirname "$0")"
SCRIPT=""

OS="$(lsb_release -is)"
case "$OS" in
    "Arch") SCRIPT="arch/arch.sh" ;;
esac

[ -n "$SCRIPT" ] && "/bin/sh" "$THIS_DIRECTORY/$SCRIPT"

check "Set up git?" && setup_git
check "Copy xorg.conf.d?" 1 && "/bin/sh" "$THIS_DIRECTORY/xorg.sh $THIS_DIRECTORY"
check "Create common files and directories?" 1 && create_files_dirs
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
check "Install programs in SCRIPTS_DIR?" && install_programs
check "Ignore local files" 1 && ignore_local_files

check "Reboot system?" 1 && reboot
