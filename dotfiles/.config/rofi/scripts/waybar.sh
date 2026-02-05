#!/bin/bash

CONFIG_DIR="$HOME/.config/waybar"
THEMES_DIR="$CONFIG_DIR/themes"

THEME_NAME=$(ls "$THEMES_DIR" | rofi -dmenu -p "Waybar Theme")

if [ -z "$THEME_NAME" ]; then
    exit 0
fi

if [ ! -d "$THEMES_DIR/$THEME_NAME" ]; then
    rofi -e "Error: Theme directory not found!"
    exit 1
fi

ln -sf "$THEMES_DIR/$THEME_NAME/config" "$CONFIG_DIR/config"

ln -sf "$THEMES_DIR/$THEME_NAME/style.css" "$CONFIG_DIR/style.css"

if pgrep -x "waybar" > /dev/null; then
    pkill -SIGUSR2 waybar
else
    waybar > /dev/null 2>&1 &
    disown
fi
