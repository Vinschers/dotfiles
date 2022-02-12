#!/bin/sh

export SCRIPTS_DIR="$HOME"/.local/scripts
export BASHDIR="$HOME"/.config/bash
export ZDOTDIR="$HOME"/.config/zsh

. "$SCRIPTS_DIR"/on_login.sh
