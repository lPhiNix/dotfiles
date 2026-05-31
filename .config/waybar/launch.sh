#!/usr/bin/env bash
#                    __           
#  _    _____ ___ __/ /  ___ _____
# | |/|/ / _ `/ // / _ \/ _ `/ __/
# |__,__/\_,_/\_, /_.__/\_,_/_/   
#            /___/   
# Script to launch Waybar, ensuring that only one instance is 
# running and that all files are flushed to disk before launching.

# Terminate already running bar instances
pkill waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Ensure all files are flushed to disk before launching
sync

# Launch main
waybar >/dev/null 2>&1 &