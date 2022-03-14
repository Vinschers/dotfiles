#!/bin/sh

# Default arguments
alias \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -v" \
	ffmpeg="ffmpeg -hide_banner" \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	fgrep='fgrep --color=auto' \
	egrep='egrep --color=auto' \
	diff="diff --color=auto" \
    yay='yay --sudoloop' \
    dmenu='dmenu -x 12 -y 12 -z 1896' \
    htop="open_htop" \
    gtop="open_gtop" \
    nvim="open_nvim" \
    mpv="mpv --input-ipc-server=/tmp/mpvsoc$(date +%s)" # This alias is important. It enables the `pauseallmpv` command.

# Shortenings
alias \
    la="ls -1A" \
	yt="youtube-dl --add-metadata -i" \
	yta="yt -x -f bestaudio/best --audio-format mp3" \
    cvenv="create_venv" \
    avenv="activate_venv" \
    p="pacman" \
    sp="sudo pacman" \
    m="make" \
    mi="make install" \
    mci="make clean install" \
    mc="make clean" \
    mic="make install clean" \
    mcic="make clean install && make clean" \

# Git
alias \
	g="git" \
    dotfiles='git --git-dir=$HOME/.dotfiles-git/ --work-tree=$HOME' \
    xfce4='git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME' \
    ds='dotfiles status' \
    da='dotfiles add' \
    gs='git status' \
    ga='git add' \
    gc='git clone' \
    gd='git diff' \
    gr='git restore' \

# Actual aliases
alias \
    python='python3' \
    code='vscodium' \
    fuck='thefuck' \
    chmime='selectdefaultapplication' \
    chtitle='change_title' \
    c='compile' \
    ex='extract' \
    o='xdg-open' \
    v="nvim" \
    get-keys="xev" \
    ct="compact_tar" \
    cz="compact_zip" \
    lf="lf-ueberzug" \

# Utils
alias \
    alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' \
    scripts='cd $SCRIPTS_DIR && ls' \
    unicamp='cd /mnt/hdd/academic/unicamp/Disciplinas/ && ls' \
