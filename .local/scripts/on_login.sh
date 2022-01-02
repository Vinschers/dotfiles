#!/bin/sh

export BASHDIR=$HOME/.config/bash
export ZDOTDIR=$HOME/.config/zsh

if [ "${SHELL#*bash}" != "$SHELL" ]
then
	. "$HOME/.bashrc"
fi
