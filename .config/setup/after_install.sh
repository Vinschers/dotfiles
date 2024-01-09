#!/bin/sh

wine() {
	export WINEDEBUG=-all
	export WINEPREFIX="$HOME/.wine"

	mkdir -p "$WINEPREFIX"

	wine hostname
	winetricks --unattended dotnet20 dotnet48 d3dcompiler_43 d3dcompiler_47 d3dx9 d3dx10 d3dx11_42 d3dx11_43 faudio vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 quartz

	setup_dxvk install
	setup_vkd3d_proton install
}

photoshop() {
    mkdir -p "$HOME/.local/share/photoshop"
    "$HOME/.config/setup/programs/photoshop2021install.sh" "$HOME/.local/share/photoshop"
}

wine
photoshop
