#!/usr/bin/env bash
#            __        __                ____                      
#   ___ ___ / /__ ____/ /_  _    _____ _/ / /__  ___ ____  ___ ____
#  (_-</ -_) / -_) __/ __/ | |/|/ / _ `/ / / _ \/ _ `/ _ \/ -_) __/
# /___/\__/_/\__/\__/\__/  |__,__/\_,_/_/_/ .__/\_,_/ .__/\__/_/   
#                                        /_/       /_/                       
# Script to select a wallpaper and generate a color 
# scheme based on the selected one

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"
CURRENT_WALLPAPER_FILE="$HOME/.config/hypr/wallpaper.sh"

SELECTED_WALLPAPER=$(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        | sed "s|$WALLPAPER_DIR/||" \
        | sort \
        | rofi -dmenu -config "$ROFI_CONFIG"
)

# Exit if the user cancels the selection.
[ -z "$SELECTED_WALLPAPER" ] && exit 0

WALLPAPER="$WALLPAPER_DIR/$SELECTED_WALLPAPER"

# Generate a color scheme from the selected wallpaper.
matugen image "$WALLPAPER" --prefer lightness

# Apply the wallpaper with a smooth transition.
awww img "$WALLPAPER" \
    --transition-type center \
    --transition-fps 144

# Create a symlink so rofi can use it as a background image.
ln -sf "$WALLPAPER" "$HOME/.config/hypr/wallpaper"