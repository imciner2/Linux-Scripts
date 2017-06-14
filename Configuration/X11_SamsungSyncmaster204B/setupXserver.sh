#!/bin/bash

# Check for being run as root
#if [ "$EUID" -ne 0 ]; then
#  echo "Please run as root"
#  exit
#fi

# Add the highest mode to the server
sudo xrandr --newmode "1600x1200@60" 162.0 1600 1664 1856 2160 1200 1201 1204 1250 +hsync +vsync

# Associate that mode with the monitor port
sudo xrandr --addmode VGA1 1600x1200@60

