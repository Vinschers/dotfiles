#!/bin/sh

add_to_path() {
    echo "$HOME/.local/bin"
    echo "$SCRIPTS_DIR"
    echo "/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"
}

PATH="$(add_to_path | paste -sd':' | tr -d '\n'):$PATH"
