#!/bin/sh

venv() {
	virtualenv ".venv"
    . .venv/bin/activate
	pip install -e . || pip install -r requirements.txt
	pip install debugpy
}

cd_venv() {
	if [ -z "$VIRTUAL_ENV" ]; then
		## If env folder is found then activate the vitualenv
		if [ -d ./.venv ]; then
			. ./.venv/bin/activate
		fi
	else
		## check the current folder belong to earlier VIRTUAL_ENV folder
		# if yes then do nothing
		# else deactivate
		parentdir="$(dirname "$VIRTUAL_ENV")"
        case "$PWD" in
            "$parentdir"*) ;;
            *)
                deactivate
                ;;
        esac
	fi
}

export create_venv
export cd_venv
