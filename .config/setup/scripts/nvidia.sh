#!/bin/sh

lspci -k | grep -A 2 -E "(VGA|3D)" | grep -qi nvidia || exit 0

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
