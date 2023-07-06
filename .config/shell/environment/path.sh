#!/bin/sh

add_to_path() {
    echo "$HOME/.local/bin"
    echo "$HOME/.scripts"
    echo "/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"
    echo "$HOME/.local/share/cargo/bin"
}

PATH="$(add_to_path | paste -sd':' | tr -d '\n'):$PATH"
