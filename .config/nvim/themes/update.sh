#!/bin/sh

update_theme() {
	ln -sf "$HOME/.config/nvim/themes/$1.lua" "$HOME"/.config/nvim/lua/plugins/colorscheme.lua
}

if [ -n "$1" ]; then
	[ "$1" -eq 1 ] && update_theme "tokyonight"
fi

sleep 1
ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
	nvim --server "$nvim_socket" --remote-send ":Lazy reload LazyVim<cr>"
done
