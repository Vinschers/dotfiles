#!/bin/sh

# Default arguments
alias \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -v" \
	ls="eza --icons --time-style long-iso" \
	grep="grep --color=auto" \
	fgrep='fgrep --color=auto' \
	egrep='egrep --color=auto' \
	diff="diff --color=auto" \
    yay='yay --sudoloop' \
    dmenu='dmenu -x 12 -y 12 -z 1896' \
    bash='bash --rcfile $BASHDIR/bashrc.sh' \
    yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# Shortenings
alias \
    la="ls -1a" \
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
    dotfiles='git --git-dir=$XDG_CONFIG_HOME/.dotfiles-git/ --work-tree=$HOME' \
    xfce4='git --git-dir=$HOME/.rice-xfce4-git/ --work-tree=$HOME' \
    ds='dotfiles status' \
    da='dotfiles add' \
    ddiff="dotfiles diff" \
    dC='dotfiles commit -m' \
    dP='dotfiles push' \
    dp='dotfiles pull' \
    dr='dotfiles restore' \
    gs='git status' \
    ga='git add' \
    gc='git clone' \
    gd='git diff' \
    gr='git restore' \
    gC='gitmoji -c' \
    gP='git push' \
    gp='git pull' \

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
    get-keys="xev" \
    ct="compact_tar" \
    cz="compact_zip" \
    lf="lfcd" \
    v="nvim"

# Utils
alias \
    alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' \
    i='yay --needed --cleanafter --answerclean None --answerdiff None --editmenu -S' \
    up='yay --devel -Syu' \
    books='cd $HOME/hdd/books/ && ls' \
    b='books' \
    se='sudoedit' \
    cv='cd $HOME/.config/nvim/' \
    cs='cd $HOME/.config/suckless/' \
    vpn='sudo openvpn $ACADEMIC_DIRECTORY/unicamp.ovpn' \
    bib='cd $ACADEMIC_DIRECTORY/bibliography && ls' \
    d='cd $ACADEMIC_DIRECTORY/unicamp/disciplinas && ls' \
    sv="sudoedit" \
    android="sudo aft-mtp-mount /mnt/android" \
    train="sl -acdeGF" \
    sctl="sudo systemctl" \
    audio="systemctl --user restart pipewire.service" \
    jn="jupyter notebook" \
    mime="file --dereference --brief --mime-type --"

# Development
alias \
    gcc='gcc -g -std=c99 -Wall -lm' \
    g++='gcc -g -std=c99 -Wall -lm'


if lspci -k 2>/dev/null | grep -A 2 -E "(VGA|3D)" | grep -qi 'nvidia\|amd'; then
    alias ffmpeg='ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi -hide_banner'
else
    alias ffmpeg='ffmpeg -hide_banner'
fi
