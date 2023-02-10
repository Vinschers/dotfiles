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
    create_symlink "$HOME/.config/Xresources" "$HOME/.Xresources"
    create_symlink "$HOME/.profile" "$HOME/.zprofile"
    create_symlink "$HOME/.config/librewolf" "$HOME/.librewolf"

    create_file "$HOME/.cache/cpustatus" "0"
    create_file "$HOME/.cache/datetime" "0"
    create_file "$HOME/.cache/diskspace" "0 1000"
    create_file "$HOME/.cache/hardware" "0"
    create_file "$HOME/.cache/weather" "0"

	sudo mkdir -p /mnt/android/
	mkdir -p "$HOME/Downloads"
}

setup_git() {
	git config --global alias.reset-hard '!f() { git reset --hard; git clean -df ; }; f'

	printf "Email: "
	read -r email

	ssh-keygen -t ed25519 -C "$email" -N "" -f "$HOME/.ssh/id_ed25519"

	eval "$(ssh-agent -s)"

	ssh-add ~/.ssh/id_ed25519

	printf "Add the key in ~/.ssh/id_ed25519 to your Git account\nKey:\n\n"
	cat ~/.ssh/id_ed25519.pub
}

install_programs() {
	git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME submodule update --init --recursive

	cd "$SCRIPTS_DIR/programs/makefile2graph" || return
	sudo make

	cd "$SCRIPTS_DIR/programs/grub2-themes" || return
	sudo ./install.sh -t stylish -s 1080p

	cd "$HOME/.config/suckless" || return
	cd dmenu || exit
	make clean install && make clean
	cd ../st || exit
	make clean install && make clean
	cd ../dwm || exit
	make clean install && make clean
	cd ../dwmblocks-async || exit
	make clean install && make clean

	curl -s "https://raw.githubusercontent.com/Vinschers/sci/main/install.sh" | /bin/sh
}

ignore_local_files() {
	cd "$SCRIPTS_DIR" || return
	git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME update-index --assume-unchanged local_environment.sh
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

	"$HOME/.config/lightdm/update.sh"
}

setup_wayland() {
    sudo ln -s "$SCRIPTS_DIR/bin/hyprland" /usr/bin/hyprland
    sudo sed -i 's|Exec=Hyprland|Exec=hyprland|g' /usr/share/wayland-sessions/hyprland.desktop
}

add_full_name() {
	printf "Full name: "
	read -r fn
	username="$(whoami)"

	sudo usermod -c "$fn" "$username"
}

setup_ufw() {
    sudo ufw default deny
}

. "$HOME/.profile"
THIS_DIRECTORY="$(dirname "$0")"
SCRIPT=""

OS="$(lsb_release -is)"
case "$OS" in
"Arch") SCRIPT="arch/arch.sh" ;;
esac

[ -n "$SCRIPT" ] && "/bin/sh" "$THIS_DIRECTORY/$SCRIPT"

check "Set up git?" && setup_git
check "Copy xorg.conf.d?" 1 && copy_xorg
check "Setup Wayland?" 1 && setup_wayland
check "Create common files and directories?" 1 && create_files_dirs
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
check "Install programs in SCRIPTS_DIR?" 1 && install_programs
check "Ignore local files" 1 && ignore_local_files
check "Add user full name?" 1 && add_full_name
check "Set up ufw?" && setup_ufw

check "Reboot system?" 1 && reboot
