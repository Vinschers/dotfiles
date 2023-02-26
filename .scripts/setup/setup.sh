#!/bin/sh

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

create_symlink() {
	if ! [ -f "$2" ] && ! [ -d "$2" ]; then
		ln -s "$1" "$2"
	fi
}

create_file() {
	[ -f "$1" ] || echo "$2" >"$1"
}

create_files_dirs() {
	create_symlink "$HOME/.config/librewolf" "$HOME/.librewolf"

	if [ "$1" = "0" ]; then
		create_file "$HOME/.cache/cpustatus" "0"
		create_file "$HOME/.cache/datetime" "0"
		create_file "$HOME/.cache/diskspace" "0 1000"
		create_file "$HOME/.cache/hardware" "0"
		create_file "$HOME/.cache/weather" "0"
	fi

	sudo mkdir -p /mnt/android/
	sudo mkdir -p /mnt/hdd/
	sudo mkdir -p /mnt/usb/

	mkdir -p "$HOME/Downloads"
}

setup_git() {
	git config --global alias.reset-hard '!f() { git reset --hard; git clean -df ; }; f'
}

install_programs() {
	git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME submodule update --init --recursive

	cd "$SCRIPTS_DIR/programs/makefile2graph" || return
	sudo make

	# cd "$SCRIPTS_DIR/programs/grub2-themes" || return
	# sudo ./install.sh -t stylish -s 1080p

	if [ "$1" = "0" ]; then
		cd "$HOME/.config/suckless" || return
		cd dmenu || exit
		make clean install && make clean
		cd ../st || exit
		make clean install && make clean
		cd ../dwm || exit
		make clean install && make clean
		cd ../dwmblocks-async || exit
		make clean install && make clean
	fi

	curl -s "https://raw.githubusercontent.com/Vinschers/sci/main/install.sh" | /bin/sh
}

ignore_local_files() {
	cd "$SCRIPTS_DIR" || return
	git --git-dir=$HOME/.config/dotfiles/.dotfiles-git/ --work-tree=$HOME update-index --assume-unchanged local_environment.sh
}

copy_xorg() {
	sudo mkdir -p /etc/X11/xorg.conf.d

	sys_type="$(cat /sys/class/dmi/id/chassis_type)"

	case "$sys_type" in
	3)
		# Desktop
		sudo cp "$THIS_DIRECTORY/xorg_config/desktop/00-keyboard.conf" /etc/X11/xorg.conf.d
		sudo cp "$THIS_DIRECTORY/xorg_config/10-nvidia-drm-outputclass.conf" /etc/X11/xorg.conf.d
		sudo cp "$THIS_DIRECTORY/xorg_config/20-nvidia.conf" /etc/X11/xorg.conf.d
		;;
	10)
		# Notebook
		sudo cp "$THIS_DIRECTORY/xorg_config/notebook/00-keyboard.conf" /etc/X11/xorg.conf.d
		;;
	*)
		echo "Unknown system"
		;;
	esac

    create_symlink "$HOME/.config/X11/xprofile" "$HOME/.xprofile"
}

setup_wayland() {
	[ -f /usr/bin/hyprland ] || sudo ln -s "$SCRIPTS_DIR/bin/hyprland/hyprland" /usr/bin/hyprland
	sudo sed -i 's|Exec=Hyprland|Exec=hyprland|g' /usr/share/wayland-sessions/hyprland.desktop
}

setup_ufw() {
	sudo ufw default deny
}

setup_zsh() {
    mkdir -p "$XDG_STATE_HOME/zsh"
    echo "source \"\$HOME/.profile\"" | sudo tee -a /etc/zsh/zshenv
    /bin/zsh
}

. "$HOME/.profile"
THIS_DIRECTORY="$(dirname "$0")"
SCRIPT=""

printf "Graphical display (0 = Xorg / 1 = Wayland): "
read -r graphical_display

OS="$(lsb_release -is)"
case "$OS" in
"Arch") SCRIPT="arch/arch.sh" ;;
esac

[ -n "$SCRIPT" ] && "/bin/sh" "$THIS_DIRECTORY/$SCRIPT" "$graphical_display"

check "Set up git?" 1 && setup_git
[ "$graphical_display" = "0" ] && check "Copy xorg.conf.d?" 1 && copy_xorg
[ "$graphical_display" = "1" ] && check "Setup Wayland?" 1 && setup_wayland
check "Create common files and directories?" 1 && create_files_dirs "$graphical_display"
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
check "Install programs in SCRIPTS_DIR?" 1 && install_programs "$graphical_display"
check "Ignore local files" 1 && ignore_local_files
check "Set up ufw?" 1 && setup_ufw
check "Setup zsh?" 1 && setup_zsh
