#!/bin/sh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"

export BASHDIR="$HOME/.config/bash"
export ZDOTDIR="$HOME/.config/zsh"

export GVIMINIT='let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.gvim" | so $MYGVIMRC'
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'

export GHCUP_USE_XDG_DIRS=true

mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/putty"
mkdir -p "$XDG_CONFIG_HOME/pg"
mkdir -p "$XDG_CONFIG_HOME/simplescreenrecorder"
mkdir -p "$XDG_CONFIG_HOME/wakatime"
mkdir -p "$XDG_CONFIG_HOME/yarn"

mkdir -p "$XDG_DATA_HOME/gnupg"
mkdir -p "$XDG_DATA_HOME/wineprefixes"

mkdir -p "$XDG_CACHE_HOME/zsh"

[ -f "$XDG_CONFIG_HOME/git/config" ] || touch "$XDG_CONFIG_HOME/git/config"
[ -f "$XDG_CONFIG_HOME/yarn/config" ] || touch "$XDG_CONFIG_HOME/yarn/config"

[ -f "$XDG_CONFIG_HOME/octave/octaverc" ] && sed -i "s|USER|$USER|g" "$XDG_CONFIG_HOME/octave/octaverc"

# echo "hsts-file = $XDG_CACHE_HOME/wget-hsts" > "$XDG_CONFIG_HOME/wgetrc"

export CHKTEXRC=$XDG_CONFIG_HOME/chktex
export ANSIBLE_HOME="${XDG_CONFIG_HOME}/ansible"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
export TEXMFHOME="$XDG_CONFIG_HOME/texmf:"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export ncmpcpp_directory="$XDG_CONFIG_HOME/ncmpcpp"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/pylintrc"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export CGDB_DIR="$XDG_CONFIG_HOME/cgdb"
export CRAWL_DIR="$XDG_DATA_HOME/crawl/"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export ELM_HOME="$XDG_CONFIG_HOME/elm"
export FCEUX_HOME="$XDG_CONFIG_HOME/fceux"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export K9SCONFIG="$XDG_CONFIG_HOME/k9s"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export XCOMPOSEFILE="$XDG_CONFIG_HOME/X11/xcompose"
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME/mathematica"
export MAXIMA_USERDIR="$XDG_CONFIG_HOME/maxima"
export MEDNAFEN_HOME="$XDG_CONFIG_HOME/mednafen"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export RECOLL_CONFDIR="$XDG_CONFIG_HOME/recoll"
export REDISCLI_RCFILE="$XDG_CONFIG_HOME/redis/redisclirc"
export DOT_SAGE="$XDG_CONFIG_HOME/sage"
export SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
export TRAVIS_CONFIG_PATH="$XDG_CONFIG_HOME/travis"
export UNCRUSTIFY_CONFIG="$XDG_CONFIG_HOME/uncrustify/uncrustify.cfg"
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
# export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

export M2_HOME="$XDG_DATA_HOME"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export GETIPLAYERUSERPREFS="$XDG_DATA_HOME/get_iplayer"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export LEDGER_FILE="$XDG_DATA_HOME/hledger.journal"
export IPFS_PATH="$XDG_DATA_HOME/ipfs"
export LEIN_HOME="$XDG_DATA_HOME/lein"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"
export PLTUSERHOME="$XDG_DATA_HOME/racket"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
export NODENV_ROOT="$XDG_DATA_HOME/nodenv"
export REDISCLI_HISTFILE="$XDG_DATA_HOME/redis/rediscli_history"
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
export STACK_ROOT="$XDG_DATA_HOME/stack"
export UNISON="$XDG_DATA_HOME/unison"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$XDG_DATA_HOME/vagrant/aliases"
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export _Z_DATA="$XDG_DATA_HOME/z"
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"
export JUPYTERLAB_DIR="$XDG_DATA_HOME/jupyter/lab"

export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export CALCHISTFILE="$XDG_CACHE_HOME/calc_history"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export KSCRIPT_CACHE_DIR="$XDG_CACHE_HOME/kscript"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export XCOMPOSECACHE="$XDG_CACHE_HOME/X11/xcompose"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/solargraph"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export TEXMACS_HOME_PATH="$XDG_STATE_HOME/texmacs"
export W3M_DIR="$XDG_STATE_HOME/w3m"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"

export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd"
