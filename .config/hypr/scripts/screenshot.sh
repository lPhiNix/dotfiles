#!/bin/sh

# Save directory in HHD
SAVE_DIR=/media/datos1/Pictures/Screenshots

# Filename based on date
FILENAME="Screenshot-$(date +%F_%T).png"
FILEPATH="$SAVE_DIR/$FILENAME"

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