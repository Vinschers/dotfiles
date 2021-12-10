#!/bin/sh

espaco () {
    echo -e "\n\n\n" >&2
}

check () {
    if [ "$2" == "1" ]
    then
        echo -n "$1 [Y/n] " >&2
        read ans

        [ "$ans" == "" ] || [ "$ans" == "Y" ] || [ "$ans" == "y" ]
    else
        echo -n "$1 [y/N] " >&2
        read ans

        ! [ "$ans" == "" ] || [ "$ans" == "N" ] || [ "$ans" == "n" ]
    fi
}

install_packages () {
	sudo pacman -S --noconfirm --needed $1
}

install_essentials () {
	install_packages "unrar zip unzip imv zathura zathura-pdf-mupdf mpv texlive-most texlive-lang"
}

install_general () {
	install_packages "htop gtop neofetch openssh python-pip shellcheck"
}

install_dwm () {
	install_packages "pamixer dunst simple-scan flameshot ttf-font-awesome ttf-joypixels noto-fonts noto-fonts-emoji ttf-inconsolata ttf-nerd-fonts-symbols otf-latinmodern-math adobe-source-code-pro-fonts"
	yay -S ttf-ubraille libxft-bgra
}

install_fonts () {
	install_packages "adobe-source-han-sans-cn-fonts adobe-source-han-sans-hk-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts adobe-source-han-serif-kr-fonts adobe-source-han-serif-otc-fonts adobe-source-han-serif-tw-fonts"
}

install_gui () {
	install_packages "xorg xorg-xinit xf86-video-intel xf86-input-wacom nvidia nvidia-utils nvidia-settings nitrogen slock pulseaudio pavucontrol alsa-utils alsa-firmware thunar"
	yay -S picom-jonaburg-git

	amixer sset Master unmute
	pulseaudio --check
	pulseaudio -D

	check "Install dwm related packages?" 1 && install_dwm ; espaco
	check "Install additional fonts?" 1 && install_fonts ; espaco
}

cp_xorg () {
	sudo cp -r ./xorg.conf.d/* /etc/X11/xorg.conf.d/
}

check "Install essential dotfiles packages?" 1 && install_essentials ; espaco
check "Install general usage packages?" 1 && install_general ; espaco
check "Install GUI packages?" 1 && install_gui ; espaco
check "Override xorg.conf.d?" 1 && cp_xorg ; espaco
