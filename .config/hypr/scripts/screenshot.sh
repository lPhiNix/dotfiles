#!/usr/bin/env bash
#                                 __        __ 
#   ___ ___________ ___ ___  ___ / /  ___  / /_
#  (_-</ __/ __/ -_) -_) _ \(_-</ _ \/ _ \/ __/
# /___/\__/_/  \__/\__/_//_/___/_//_/\___/\__/ 
#
# Script to capture the entire screen or just a portion, 
# which is saved to disk and copied to the clipboard 

# Save directory in HHD
SAVE_DIR=~/Pictures/screenshots

# Filename based on date
FILENAME="Screenshot-$(date +%F_%T).png"
FILEPATH="$SAVE_DIR/$FILENAME"

mkdir -p "$SAVE_DIR"

if [ "$1" = "area" ]; then
    sleep 1
    grimblast --freeze --notify copysave area $FILEPATH
elif [ "$1" = "full" ]; then
    sleep 1
    grimblast --freeze --notify copysave output $FILEPATH
else
    echo "Usage: $0 [area|full]"
    exit 1
fi