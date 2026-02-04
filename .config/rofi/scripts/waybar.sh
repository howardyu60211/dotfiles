#!/bin/bash

CONFIG_DIR="$HOME/dotfiles/waybar"

STYLE_1="  Standard"
STYLE_2=" pí  Minimal"
STYLE_3="  Floating Bar"

options="$STYLE_1\n$STYLE_2\n$STYLE_3"

selected=$(echo -e "$options" | rofi -dmenu -i -p "  Waybar Style")

case $selected in
    "$STYLE_1")
        ln -sf "$CONFIG_DIR/config_standard" "$HOME/.config/waybar/config"
        ln -sf "$CONFIG_DIR/style_standard.css" "$HOME/.config/waybar/style.css"
        ;;
    "$STYLE_2")
        ln -sf "$CONFIG_DIR/config_minimal" "$HOME/.config/waybar/config"
        ln -sf "$CONFIG_DIR/style_minimal.css" "$HOME/.config/waybar/style.css"
        ;;
    "$STYLE_3")
        ln -sf "$CONFIG_DIR/config_floating" "$HOME/.config/waybar/config"
        ln -sf "$CONFIG_DIR/style_floating.css" "$HOME/.config/waybar/style.css"
        ;;
esac

if [ -n "$selected" ]; then
    killall waybar
    waybar &
    notify-send "Waybar reloaded" "$selected"
fi
