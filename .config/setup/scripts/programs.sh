#!/bin/sh

setup_dir="$1"

if [ -d "$setup_dir/programs/makefile2graph" ] && ! command -v makefile2graph >/dev/null; then
	cd "$setup_dir/programs/makefile2graph" || exit 0
	sudo make
fi

if [ -d /etc/firejail ]; then
	sudo sed -i "s|^chafa|#chafa|g" /etc/firejail/firecfg.config
	sudo sed -i "s|^man|#man|g" /etc/firejail/firecfg.config
	sudo sed -i "s|^zathura|#zathura|g" /etc/firejail/firecfg.config

	sudo firecfg
fi
