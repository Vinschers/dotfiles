#!/bin/sh


errors=""

check() {
	if [ "$2" = "1" ]; then
		printf "%s [Y/n] " "$1" >&2
		read -r ans

		[ "$ans" = "" ] || [ "$ans" = "Y" ] || [ "$ans" = "y" ]
	else
		printf "%s [y/N] " "$1" >&2
		read -r ans

		! [ "$ans" = "" ] && ! [ "$ans" = "N" ] && ! [ "$ans" = "n" ]
	fi
}

THIS_DIRECTORY="$(dirname "$0")"

setup_wacom() {
	sudo pacman --noconfirm -S xf86-input-wacom

	sudo mkdir /usr/share/wacom
	sudo ln -s "$SCRIPTS_DIR/devices/wacom.sh" /usr/share/wacom/wacom.sh

	echo "ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"056a\", TAG+=\"systemd\", ENV{SYSTEMD_USER_WANTS}+=\"wacom.service\"" | sudo tee /etc/udev/rules.d/99-wacom.rules

	systemctl enable --user "$HOME/.config/systemd/user/wacom.service"
}

install_packages() {

	while read -r PACKAGE; do
		printf "\n\n\nInstalling %s..." "$PACKAGE"
		sudo pacman -S --noconfirm --needed "$PACKAGE" || errors="$errors $PACKAGE"
	done <"$THIS_DIRECTORY/pacman"

	while read -r PACKAGE; do
		printf "\n\n\nInstalling %s..." "$PACKAGE"
		yay --noconfirm -S "$PACKAGE" || errors="$errors $PACKAGE"
	done <"$THIS_DIRECTORY/yay"

	amixer sset Master unmute
	pulseaudio --check
	pulseaudio -D

	pip install undetected-chromedriver
	sudo pacman --noconfirm -Rns gnu-free-fonts

	sudo systemctl enable zotero-translation-server.service
	sudo systemctl enable lightdm

    sudo sed -i '/"memory"/c\  <policy domain="resource" name="memory" value="2GiB"/>' /etc/ImageMagick-7/policy.xml

}

setup_pacman() {
	sudo sed -i 's/^.*\bParallelDownloads\b.*$/ParallelDownloads = 6/g' /etc/pacman.conf
	sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf
	sudo sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
	sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

	sudo pacman -Sy
}

setup_nvidia() {
	sudo pacman --noconfirm -S nvidia nvidia-settings nvidia-utils opencl-nvidia
	echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia-drm-nomodeset.conf
	sudo mkinitcpio -P
}

install_extra() {
    sudo pacman --noconfirm --needed -S discord || errors="$errors discord"
    yay --noconfirm -S spotify || errors="$errors spotify"
    yay --noconfirm -S spicetify-cli || errors="$errors spicetify-cli"
    yay --noconfirm -S betterdiscord-installer || errors="$errors betterdiscord-installer"
    yay --noconfirm -S ncspot || errors="$errors ncspot"
    # yay --noconfirm -S librewolf-bin

    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
}

check "Setup wacom?" 1 && setup_wacom
check "Install packages?" 1 && install_packages
check "Setup pacman.conf?" 1 && setup_pacman
check "Setup NVIDIA?" 0 && setup_nvidia
check "Install extra packages?" 0 && install_extra
check "Remove unnecessary dependencies?" 1 && sudo pacman --noconfirm -Runcs $(pacman -Qdtq)

[ -n "$errors" ] && echo "$errors" > "$HOME/pkg_errors" && echo "Failed packages saved to ~/pkg_errors."
