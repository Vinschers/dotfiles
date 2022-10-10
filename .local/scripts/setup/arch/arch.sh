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

THIS_DIRECTORY="$(dirname "$0")"

setup_wacom () {
    sudo mkdir /usr/share/wacom
    sudo ln -s "$SCRIPTS_DIR/devices/wacom.sh" /usr/share/wacom/wacom.sh

    echo "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", TAG+=\"systemd\", ENV{SYSTEMD_USER_WANTS}+=\"wacom.service\"" | sudo tee /etc/udev/rules.d/99-wacom.rules

    systemctl enable --user "$HOME/.config/systemd/user/wacom.service"
}

install_packages () {

    while read -r PACKAGE
    do
        echo -e "\n\n\nInstalling $PACKAGE..."
        sudo pacman -S --noconfirm --needed "$PACKAGE"
    done < "$THIS_DIRECTORY/pacman"

    yay -S libxft-bgra

    while read -r PACKAGE
    do
        echo -e "\n\n\nInstalling $PACKAGE..."
        yay --noconfirm -S "$PACKAGE"
    done < "$THIS_DIRECTORY/yay"

	amixer sset Master unmute
	pulseaudio --check
	pulseaudio -D

    sudo patch /usr/lib/node_modules/translation-server/modules/utilities/utilities_item.js "$SCRIPTS_DIR/programs/utilities_item.js.diff"
    sudo systemctl enable zotero-translation-server.service
}

check "Setup wacom?" 1 && setup_wacom
check "Install packages?" 1 && install_packages
