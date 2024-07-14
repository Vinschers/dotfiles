#!/bin/sh

hyprland() {
    hyprpm update
    echo "y" | hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
    hyprpm enable split-monitor-workspaces
}

setup_wine() {
	export WINEDEBUG=-all

	mkdir -p "$WINEPREFIX"

	wine hostname
	winetricks --unattended dotnet20 dotnet48 d3dcompiler_43 d3dx9 d3dx10 d3dx11_42 d3dx11_43 faudio vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 quartz fontsmooth=rgb gdiplus msxml3 msxml6 atmlib

	setup_dxvk install
	setup_vkd3d_proton install
}

photoshop() {
    mkdir -p "$HOME/.local/share/photoshop"
    "$HOME/.config/setup/programs/photoshop2021install.sh" "$HOME/.local/share/photoshop"
}

hyprland
setup_wine
photoshop
