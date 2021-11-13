#!/usr/bin/env bash
ISSH_DIR="/sdcard/.issh"
ISSH_PATH="$ISSH_DIR/issh"
ISSH_RAW_URL="https://raw.githubusercontent.com/tytydraco/issh/main/issh"

# Make the issh files directory if it does not yet exist
mkdir -p "$ISSH_DIR"

# Pull latest issh script to the device
curl -sLo "$ISSH_PATH" "$ISSH_RAW_URL"

# Kill any running issh servers
pkill toybox

# Fork issh daemon for localhost connections only
nice -n -20 -- sh "$ISSH_PATH" -dl &
