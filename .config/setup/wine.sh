#!/bin/sh

alias winecfg="WINEPREFIX=$HOME/.wine winecfg"
alias winetricks="WINEPREFIX=$HOME/.wine winetricks"
alias setup_dxvk="WINEPREFIX=$HOME/.wine setup_dxvk"

winecfg
winetricks --force dotnet20 dotnet48 d3dcompiler_43 d3dcompiler_47 d3dx9 d3dx10 d3dx11_42 d3dx11_43 faudio vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 quartz
setup_dxvk install
