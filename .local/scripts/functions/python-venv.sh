#!/bin/sh


activate_venv () {
    source "$1"/bin/activate
}
create_venv () {
    virtualenv "$1"
    activate_venv "$1"
    pip install -e . || pip install -r requirements.txt
}

export activate_venv
export create_venv
