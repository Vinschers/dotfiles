#!/bin/sh

if [ -d "$HOME/.config/setup/programs/makefile2graph" ] && ! command -v makefile2graph >/dev/null; then
	cd "$HOME/.config/setup/programs/makefile2graph" || exit 0
	sudo make
fi

if [ -d /etc/firejail ]; then
	sudo sed -i "s|^chafa|#chafa|g" /etc/firejail/firecfg.config
	sudo sed -i "s|^man|#man|g" /etc/firejail/firecfg.config
	sudo sed -i "s|^zathura|#zathura|g" /etc/firejail/firecfg.config

	sudo firecfg >/dev/null
fi
