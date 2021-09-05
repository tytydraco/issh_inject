#!/usr/bin/env bash
TMPFILE="$(mktemp)"
ISSH_REMOTE_PATH="/sdcard/issh"
ISSH_RAW_URL="https://raw.githubusercontent.com/tytydraco/issh/main/issh"

# Wait for a device to be connected
adb wait-for-device

# Pull latest issh script
curl -sLo "$TMPFILE" "$ISSH_RAW_URL"

# Push issh script to device temporary directory
adb push "$TMPFILE" "$ISSH_REMOTE_PATH"

# Kill any running issh servers
adb shell "pkill toybox"

# Fork issh daemon for localhost connections only
# We also fork the shell command here as it tends to get stuck
adb shell "sh $ISSH_REMOTE_PATH -dl" &

# Press the power button to indicate completion
adb shell input keyevent 26

