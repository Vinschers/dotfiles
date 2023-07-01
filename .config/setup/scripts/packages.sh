#!/bin/sh

setup_dir="$1"
errors=""

sudo sed -i 's/^.*\bParallelDownloads\b.*$/ParallelDownloads = 6/g' /etc/pacman.conf
sudo sed -i 's/^#Color/Color/g' /etc/pacman.conf
grep -q ILoveCandy /etc/pacman.conf && sudo sed -i 's/VerbosePkgLists/VerbosePkgLists\nILoveCandy/g' /etc/pacman.conf
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

sudo pacman -Syu

install_packages() {
	pkgs_file="$1"

	[ -f "$pkgs_file" ] || exit 0

	while read -r pkg; do
        yay --sudoloop --noconfirm --needed -S "$pkg" >/dev/null || errors="$errors $pkg"
	done <"$pkgs_file"
}

install_extra_packages() {
	pip install undetected-chromedriver || errors="$errors undetected-chromedriver"
	npm i -g neovim
}

setup_sddm() {
	sudo sed -i 's|Login!!|Login|g' /usr/share/sddm/themes/corners/theme.conf
	sudo sed -i 's|hh:mm AP|HH:mm|g' /usr/share/sddm/themes/corners/theme.conf
}

setup_security() {
	sudo freshclam
}

setup_imagemagick() {
	sudo sed -i '/"memory"/c\  <policy domain="resource" name="memory" value="2GiB"/>' /etc/ImageMagick-7/policy.xml
}

setup_vbox() {
	sudo usermod -aG vboxusers "$USER"
	sudo usermod -aG video "$USER"
}

setup_rust() {
	rustup default stable
}

setup_bat() {
	bat cache --build
}

setup_spicetify() {
	sudo groupadd spicetify
	sudo usermod -a -G spicetify "$USER"
	sudo chgrp spicetify /opt/spotify
	sudo chgrp -R spicetify /opt/spotify/Apps
	sudo chmod 775 /opt/spotify
	sudo chmod 775 -R /opt/spotify/Apps
    spicetify backup
    mkdir -p "$HOME/.config/spicetify/Themes/default"
}

start_systemd_services() {
	sudo systemctl enable sddm.service
	sudo systemctl enable clamav-daemon.service
	sudo systemctl enable zotero-translation-server.service
	systemctl --user daemon-reload
	systemctl --user enable opentabletdriver --now
}

setup_packges() {
    setup_sddm
    setup_security
    setup_imagemagick
    setup_vbox
    setup_rust
    setup_bat
    setup_spicetify

    start_systemd_services
}

install_packages "$setup_dir/packages/dependencies"
install_packages "$setup_dir/packages/general"
install_packages "$setup_dir/packages/fonts"
install_packages "$setup_dir/packages/development"
install_packages "$setup_dir/packages/wayland"
install_packages "$setup_dir/packages/gui"
[ "$(cat /sys/class/dmi/id/chassis_type)" = "10" ] && install_packages "$setup_dir/packages/notebook"

if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi nvidia; then
    install_packages "$setup_dir/packages/nvidia"
	yay --sudoloop --noconfirm -S "hyprland-nvidia" || errors="$errors hyprland-nvidia"
else
	yay --sudoloop --noconfirm -S "hyprland" || errors="$errors hyprland"
fi

setup_packges

[ -d "$HOME/.dotnet" ] && rm -rf "$HOME/.dotnet"
