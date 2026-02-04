#!/bin/bash

WALL_DIR="$HOME/dotfiles/wallpapers"
CACHE_DIR="$HOME/.cache/rofi-wallpaper"

if [ ! -d "$WALL_DIR" ]; then
    echo "Wallpaper directory not found!"
    exit 1
fi

selected=$(ls "$WALL_DIR" | grep -E '\.(jpg|jpeg|png|gif|webp)$' | rofi -dmenu -i -p "  Wallpaper" -theme-str 'window {width: 500px;}')

if [ -n "$selected" ]; then
    swww img "$WALL_DIR/$selected" --transition-type grow --transition-pos 0.9,0.9 --transition-step 90

    # echo "$WALL_DIR/$selected" > ~/.current_wallpaper

    notify-send "Wallpaper Changed" "$selected" -i "$WALL_DIR/$selected"
fi
