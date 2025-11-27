#!/bin/bash
# Wallpaper rotation script for i3
# Rotates wallpapers from ~/Pictures/Wallpapers every 10 minutes

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
INTERVAL=600  # 10 minutes in seconds

# Function to set a random wallpaper
set_random_wallpaper() {
    # Find all image files in the wallpaper directory
    mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    # Select a random wallpaper
    random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

    # Set the wallpaper using feh
    feh --bg-scale "$random_wallpaper"

    echo "$(date): Set wallpaper to $random_wallpaper"
}

# Set initial wallpaper
set_random_wallpaper

# Loop forever, changing wallpaper every INTERVAL seconds
while true; do
    sleep "$INTERVAL"
    set_random_wallpaper
done
