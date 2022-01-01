#!/bin/sh


THIS_DIRECTORY="$(dirname "$0")"

espaco () {
    echo -e "\n\n\n" >&2
}

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

install_packages () {
	sudo pacman -S --noconfirm --needed $1
}

install_essentials () {
	install_packages "unrar zip unzip imv zathura zathura-pdf-mupdf mpv"
}

install_general () {
	install_packages "htop gtop neofetch openssh shellcheck xclip neovim python-pip linux-headers"
}

install_dwm_fonts () {
	install_packages "ttf-font-awesome ttf-joypixels noto-fonts-emoji otf-latinmodern-math adobe-source-code-pro-fonts"
    yay -S adobe-source-han-mono-tw-fonts
}

install_dwm () {
	install_packages "imlib2 pamixer dunst simple-scan flameshot"
	yay -S colorpicker
	yay -S xkb_switch

    check "Install dwm related fonts?" 1 && install_dwm_fonts ; espaco
}

install_fonts () {
	install_packages "adobe-source-han-sans-cn-fonts adobe-source-han-sans-hk-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-jp-fonts adobe-source-han-serif-kr-fonts adobe-source-han-serif-otc-fonts adobe-source-han-serif-tw-fonts"
}

install_latex () {
  install_packages "texlive-most texlive-lang"
}

install_gui () {
	yay -S libxft-bgra-git
	install_packages "xorg xorg-xinit xf86-video-intel xf86-input-wacom nvidia nvidia-utils nvidia-settings nitrogen slock pulseaudio pavucontrol alsa-utils alsa-firmware thunar"
    yay -S picom-jonaburg-git

	check "Install dwm related packages?" 1 && install_dwm ; espaco
	check "Install additional fonts?" 1 && install_fonts ; espaco
    check "Install LaTeX packages?" 1 && install_latex ; espaco

	amixer sset Master unmute
	pulseaudio --check
	pulseaudio -D
}

cp_xorg () {
	sudo cp -r "$THIS_DIRECTORY"/xorg.conf.d/* /etc/X11/xorg.conf.d/
}

create_cache () {
    echo "0 1000" > "$HOME"/.cache/diskspace
    echo "0 0" > "$HOME"/.cache/price
    echo "0 0 0" > "$HOME"/.cache/netlog
}

check "Install essential dotfiles packages?" 1 && install_essentials ; espaco
check "Install general usage packages?" 1 && install_general ; espaco
check "Install GUI packages?" 1 && install_gui ; espaco
check "Override xorg.conf.d?" 1 && cp_xorg ; espaco
check "Create .cache files for dwmblocks?" 1 && create_cache ; espaco
