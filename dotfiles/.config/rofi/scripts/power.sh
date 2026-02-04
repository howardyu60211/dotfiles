#!/bin/bash

shutdown=" Shutdown"
reboot=" Reboot"
lock=" Lock"
suspend=" Suspend"
logout=" Logout"

options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

selected=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 300px;}')

case $selected in
    "$shutdown")
        systemctl poweroff ;;
    "$reboot")
        systemctl reboot ;;
    "$lock")
        hyprlock ;;
    "$suspend")
        systemctl suspend ;;
    "$logout")
        hyprctl dispatch exit ;;
esac
