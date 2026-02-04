#!/bin/bash

# 定義主題選項
THEME_1=" Dark Mode (Mocha)"
THEME_2=" Light Mode (Latte)"
THEME_3=" Hacker Mode (Green)"

options="$THEME_1\n$THEME_2\n$THEME_3"

selected=$(echo -e "$options" | rofi -dmenu -i -p "  Global Theme")

case $selected in
    "$THEME_1")
        # 在這裡填入切換到 Dark Mode 的指令
        # 例如：
        # cp ~/dotfiles/hypr/mocha.conf ~/.config/hypr/colors.conf
        # cp ~/dotfiles/kitty/mocha.conf ~/.config/kitty/theme.conf
        # gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha"

        killall -SIGUSR1 kitty # reload kitty
        hyprctl reload
        notify-send "Theme set to Dark Mode"
        ;;

    "$THEME_2")
        # 填入切換到 Light Mode 的指令
        notify-send "Theme set to Light Mode"
        ;;
esac
