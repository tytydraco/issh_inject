#!/usr/bin/env bash

ISSH_DIR="/sdcard/.issh"
ISSH_PATH="$ISSH_DIR/issh"
ISSH_RAW_URL="https://raw.githubusercontent.com/tytydraco/issh/main/issh"

dbg() {
    echo -e "\e[36m * $*\e[0m"
}

# Make the issh files directory if it does not yet exist
prepare_env() {
    dbg "Preparing the device environment..."
    adb shell "mkdir -p $ISSH_DIR"
}

# Push latest issh script to the device
fetch_issh() {
    local tmp
    tmp="$(mktemp)"

    dbg "Fetching the lastet issh script..."
    curl -#Lo "$tmp" "$ISSH_RAW_URL"

    dbg "Pushing issh to the device..."
    adb push "$tmp" "$ISSH_PATH"

    dbg "Cleaning up..."
    rm -f "$tmp"
}

# Fork issh daemon
bootstrap() {
    dbg "Killing any existing issh processes..."
    adb shell "pkill toybox"

    dbg "Bootstrapping issh daemon..."
    adb shell "nice -n -20 -- sh $ISSH_PATH -dl" &
}

prepare_env
fetch_issh
bootstrap
dbg "Done."
