#! /usr/bin/env python3

import pyudev
import time
import subprocess

# These are the two vendor:device IDs for the USB/Bluetooth connections of the keyboard
allowedDevices = ["004C:026C", "05AC:026C"]

ctx = pyudev.Context()
monitor = pyudev.Monitor.from_netlink(ctx)
monitor.filter_by("input")

for device in iter(monitor.poll, None):
    # The mapping is only messed up on add
    if device.action != "add":
        continue

    if not device.is_initialized:
        continue

    for devid in allowedDevices:
        if devid in device.device_path:
            time.sleep(1)
            subprocess.run("xkbcomp -w0 -I$HOME/local/share/xkbd -R$HOME/local/share/xkbd keymaps/magic_keymap $DISPLAY", shell=True)
