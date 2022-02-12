#!/bin/sh

if [ "${SHELL#*bash}" != "$SHELL" ]
then
	. "$BASHDIR/bashrc.sh"
fi
