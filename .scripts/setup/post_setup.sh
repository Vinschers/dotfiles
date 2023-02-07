#!/bin/sh

if [ -d /opt/spotify ]; then
	sudo chmod a+wr /opt/spotify
	sudo chmod a+wr /opt/spotify/Apps -R
fi

touch "$HOME/.cache/post_setup"
