# issh_inject
Inject a semi-priviledged issh server into a live Android device via ADB

# Logic
Injecting an issh server with ADB permissions allows non-privileged users to execute privileged commands without using ADB. This solution can be compared to a semi-untethered iOS jailbreak, where a computer is necessary to jailbreak the device every reboot. Similarly, the issh server must be re-injected on every device reboot.

# Process
1. The lastest issh script is pulled from the [official repository](https://github.com/tytydraco/issh)
2. Any running issh servers are killed
3. Start the issh daemon with adb privileges (localhost connections only)

# Inject
1. Connect an Android device and verify that ADB permissions are granted
2. Run the script: `bash inject.sh`  
  2a. Alternatively, use the python program: `python inject.py`
3. After injection, the script can be deleted. However, you may want to keep it to make future injections easier.
4. NOTE: You may hang on the bootstrapping step. This is normal, you may unplug the device after a second or two.

# Verify
1. `adb shell "netstat -an | grep 65432"`. If there is no output, then the issh server is not running. The desired output should show an open TCP connection to localhost (127.0.0.1) open on port 65432.

# Uninstall
1. `rm -rf /sdcard/.issh`
2. Reboot

# Raspberry Pi auto-inject
You can have a Raspberry Pi execute the issh daemon when an Android device is connected. This is the ideal solution for on-the-go emergency issh injections. The setup is very simple.

1. Install [Raspberry Pi OS](https://www.raspberrypi.com/software/operating-systems/) to an unused SD card
2. Make sure to enable headless ssh by placing an empty file called `ssh` in the boot partition
3. Boot into the installation and SSH into the Raspberry PI
4. Install ADB: `apt install android-tools-adb`
5. Edit `/etc/rc.local` and add `setsid /root/kickoff &` to the empty line before `exit 0`
6. Make a new file at `/root/kickoff` and insert the following contents:

```sh
#!/usr/bin/env bash

while true
do
	adb wait-for-device
	adb shell "setsid nice -n -20 -- sh /sdcard/.issh/issh -dl &"
	adb shell "input keyevent 26"
	adb disconnect
done
```

7. Make the script executable: `chmod +x kickoff`
8. On your Android devices, place the issh script at `/sdcard/.issh/issh`
