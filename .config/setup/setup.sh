#!/bin/sh

if ! [ -d "$HOME/.config/dotfiles/.dotfiles-git" ]; then
	mkdir -p "$HOME/.config/dotfiles"
	git clone --bare https://github.com/Vinschers/dotfiles.git "$HOME/.config/dotfiles/.dotfiles-git"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} rm "$HOME/{}"
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" checkout
	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git/" --work-tree="$HOME" config --local status.showUntrackedFiles no

	git --git-dir="$HOME/.config/dotfiles/.dotfiles-git" --work-tree="$HOME" update-index --assume-unchanged "$HOME/.config/shell/environment/local.sh"
fi

sudo pacman -S --needed ansible-core ansible
ansible-galaxy collection install -r requirements.yml

export NVIDIA=0
lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi nvidia && NVIDIA=1

. "$HOME/.config/shell/environment/xdg.sh"

ansible-playbook --ask-become-pass "$HOME/.config/setup/bootstrap.yml"

if [ "$NVIDIA" = "1" ]; then
	if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
		sudo sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ nvidia_drm.modeset=1"/g' /etc/default/grub
		grub-mkconfig -o /boot/grub/grub.cfg
	fi

	if ! grep -q "nvidia nvidia_modeset nvidia_uvm nvidia_drm" /etc/mkinitcpio.conf; then
		default_modules="$(grep "^MODULES=" /etc/mkinitcpio.conf)"
		modified_modules="${default_modules%?} nvidia nvidia_modeset nvidia_uvm nvidia_drm)"
		modified_modules="$(echo "$modified_modules" | sed 's/( /(/g')"

		sudo sed -i "s|^$default_modules|$modified_modules|g" /etc/mkinitcpio.conf
		sudo mkinitcpio -P
	fi

	if ! grep -q "options nvidia-drm modeset=1" /etc/modprobe.d/nvidia.conf; then
		echo "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
	fi

fi

printf "Setup SSD trim? [Y/n] "
read -r ssd

if [ "$ssd" = "" ] || [ "$ssd" = "Y" ] || [ "$ssd" = "y" ]; then
	sudo systemctl enable fstrim.timer fstrim.service
fi
