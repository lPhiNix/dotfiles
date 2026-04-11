#!/usr/bin/env bash
#                      _                
# __      ____ _ _   _| |__   __ _ _ __ 
# \ \ /\ / / _` | | | | '_ \ / _` | '__|
#  \ V  V / (_| | |_| | |_) | (_| | |   
#   \_/\_/ \__,_|\__, |_.__/ \__,_|_|   
#                |___/    
# Terminate already running bar instances
pkill waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
waybar >/dev/null 2>&1 &