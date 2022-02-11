#!/bin/sh


alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

alias np='nano -w PKGBUILD'
alias more=less

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# adds verbosity where we like it and shortens common commands.
alias \
	bat="cat /sys/class/power_supply/BAT?/capacity" \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -v" \
	mkd="mkdir -pv" \
	yt="youtube-dl --add-metadata -i" \
	yta="yt -x -f bestaudio/best --audio-format mp3" \
	ffmpeg="ffmpeg -hide_banner" \
  	ka="killall" \
	g="git" \
	trem="transmission-remote" \
	YT="youtube-viewer" \
	sdn="sudo shutdown -h now" \
	f="$FILE" \
	e="$EDITOR" \
	v="$EDITOR" \

# adds color to commands.
alias \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	fgrep='fgrep --color=auto' \
	egrep='egrep --color=auto' \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi"

# This alias is important. It enables the `pauseallmpv` command.
alias mpv="mpv --input-ipc-server=/tmp/mpvsoc$(date +%s)"

# Some other stuff
alias \
	python="python3"\

alias code="vscodium"

alias fuck='thefuck'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME'
alias xfce4='/usr/bin/git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME'
alias v='nvim'
alias yay='yay --sudoloop'
alias c='$SCRIPTS_DIR/utils/compile.sh'
alias cr='$SCRIPTS_DIR/utils/compileAndRun.sh'
alias ex='$SCRIPTS_DIR/utils/extractor.sh'
alias o='xdg-open'
alias chmime='selectdefaultapplication'
alias scim='sc-im'
alias scripts='cd $SCRIPTS_DIR && ls'
alias unicamp='cd /mnt/Unicamp/"$SEMESTER"semestre/ && ls'
alias gs='git status'
alias dmenu='dmenu -x 12 -y 12 -z 1896'
alias ds='dotfiles status'
alias da='dotfiles add'
