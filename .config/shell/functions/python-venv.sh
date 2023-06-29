#!/bin/sh

create_venv() {
	virtualenv "$1"
	activate_venv "$1"
	pip install -e . || pip install -r requirements.txt
	pip install debugpy
}

export create_venv
