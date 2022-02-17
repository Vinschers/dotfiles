#!/bin/sh


check () {
    if [ "$2" = "1" ]
    then
        echo -n "$1 [Y/n] " >&2
        read ans

        [ "$ans" = "" ] || [ "$ans" = "Y" ] || [ "$ans" = "y" ]
    else
        echo -n "$1 [y/N] " >&2
        read ans

        ! [ "$ans" = "" ] || [ "$ans" = "N" ] || [ "$ans" = "n" ]
    fi
}

center() {
	termwidth="60"
	padding="$(printf '%0.1s' ={1..500})"
	txt=""
	! [ "$1" = "" ] && txt=" $1 " && termwidth=$(( termwidth-2 ))
	printf '%*.*s%s%*.*s\n' 0 "$(((termwidth-${#1})/2))" "$padding" "$txt" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

show_menu() {
	center "Select current distro"
	echo ""
	echo -e "1.\tArch"

	echo ""
	center ""
	echo ""
	echo -n "Option: "
}


setup_jdtls () {
    JDTLS_PATH="$HOME/.local/share/nvim/jdtls"
    mkdir -p "$JDTLS_PATH"
    curl "https://download.eclipse.org/jdtls/milestones/1.8.0/jdt-language-server-1.8.0-202201261434.tar.gz" -o "$JDTLS_PATH/jdt-language-server.tar.gz"
    tar xzf "$JDTLS_PATH/jdt-language-server.tar.gz"
    cd "$JDTLS_PATH"
    git clone "https://github.com/microsoft/java-debug.git"
    cd "java-debug"
    ./mvnw clean install
}

show_menu
read opt

THIS_DIRECTORY="$(dirname "$0")"
SCRIPT=""

case "$opt" in
	"1") SCRIPT="arch/arch.sh" ;;
	"*") exit 1 ;;
esac

center "Running $SCRIPT script"
"/bin/sh" "$THIS_DIRECTORY/$SCRIPT"
center ""

check "Set up git ssh configuration?" && "/bin/sh" "$THIS_DIRECTORY/git-ssh.sh"
check "Install java support for Neovim?" 1 && setup_jdtls
check "Copy xorg.conf.d?" 1 && sudo cp -r "$THIS_DIRECTORY/xorg.conf.d" /etc/X11/
check "Change shell to zsh?" 1 && chsh -s /bin/zsh "$USER"
