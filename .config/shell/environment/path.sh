#!/bin/sh


add_to_path() {
    echo "/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"
    echo "$HOME/.local/bin"
    echo "$HOME/.local/share/cargo/bin"
    echo "$HOME/.local/share/python/bin"
}

PATH="$(add_to_path | paste -sd':' | tr -d '\n'):$PATH"
