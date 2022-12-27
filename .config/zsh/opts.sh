#!/bin/sh


HISTFILE=~/.zsh_history
setopt appendhistory
HISTSIZE=10000
SAVEHIST=10000

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef
zle_highlight=('paste:none')

unsetopt BEEP


# completions
autoload -U compinit; compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -Uz colors && colors

bindkey     "^[[H"      beginning-of-line
bindkey     "^[[4~"     end-of-line
bindkey     "^[[P"      delete-char
bindkey -s  "^o"        "^ulf\n"
