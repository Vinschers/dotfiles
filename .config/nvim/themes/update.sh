#!/bin/sh

update_theme() {
	ln -sf "$HOME/.config/nvim/themes/$1.lua" "$HOME"/.config/nvim/lua/utils/colorscheme.lua
}

if [ -n "$1" ]; then
	[ "$1" -eq 1 ] && update_theme "tokyonight"
fi

ss -a | grep nvim | awk '{print $5}' | while read -r nvim_socket; do
	nvim --server "$nvim_socket" --remote-send ":lua package.loaded['utils.colorscheme'] = nil; vim.cmd.colorscheme(require('utils.colorscheme').theme)<cr>"
done
