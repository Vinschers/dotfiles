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
    bash='bash --rcfile $BASHDIR/bashrc.sh' \
    discord="discord --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy"

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
    dmusic="yt-dlp -x"

# Git
alias \
    g="git" \
    dotfiles='git --git-dir=$XDG_CONFIG_HOME/.dotfiles-git/ --work-tree=$HOME' \
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
    gp='git pull'

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
    nv="neovide" \
    cv="convert_video"

# Utils
alias \
    alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"' \
    i='yay --needed --sudoloop --cleanafter --answerclean All --answerdiff None --removemake -S' \
    up='rustup update && yay --devel --cleanafter --answerclean None --answerdiff None' \
    books='cd $HOME/hdd/books/ && ls' \
    b='books' \
    se='sudoedit' \
    cs='cd $HOME/.config/suckless/' \
    vpn='sudo openvpn $HOME/academic/unicamp.ovpn' \
    bib='cd $ACADEMIC_DIRECTORY/bibliography && ls' \
    d='cd $ACADEMIC_DIRECTORY/unicamp/disciplinas && ls' \
    sv="sudoedit" \
    android="sudo aft-mtp-mount /mnt/android" \
    train="sl -acdeGF" \
    sctl="sudo systemctl" \
    audio="systemctl --user restart pipewire.service" \
    jn="jupyter notebook" \
    mime="file --dereference --brief --mime-type --" \
    webcam='mpv --untimed --no-cache --no-osc --no-input-default-bindings --profile=low-latency --input-conf=/dev/null --title=webcam "$(ls /dev/video* | tail -2 | head -1)"'

# Development
alias \
    gcc='gcc -g -std=c99 -Wall -lm' \
    g++='gcc -g -std=c99 -Wall -lm'
