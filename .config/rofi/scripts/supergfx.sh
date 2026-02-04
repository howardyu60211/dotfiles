#!/bin/bash
# rofi-gfx.sh

CURRENT_MODE=$(supergfxctl -g)

INTEGRATED="🍃 Integrated (Max Battery)"
HYBRID="🚀 Hybrid (Gaming/Performance)"
VFIO="🔒 VFIO (VM Passthrough)"

# 標示當前模式
if [ "$CURRENT_MODE" == "Integrated" ]; then
    INTEGRATED="🍃 Integrated (Current)"
elif [ "$CURRENT_MODE" == "Hybrid" ]; then
    HYBRID="🚀 Hybrid (Current)"
fi

OPTIONS="$INTEGRATED\n$HYBRID"

SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "GPU Mode ($CURRENT_MODE)" -theme-str 'window {width: 400px;}')

case "$SELECTED" in
    *"Integrated"*)
        notify-send "GPU" "Switching to Integrated Mode... Please Logout."
        supergfxctl -m Integrated
        ;;
    *"Hybrid"*)
        notify-send "GPU" "Switching to Hybrid Mode... Please Logout."
        supergfxctl -m Hybrid
        ;;
esac
