#!/bin/bash

# --- 設定 ---
# Rofi 的顯示設定 (配合你的主題)
ROFI_CMD="rofi -modi clipboard:rofi-img-cliphist -show clipboard -show-icons"

case $1 in
    "wipe")
        # 清空模式：跳出確認視窗
        CONFIRM=$(echo -e "Yes\nNo" | $ROFI_CMD -p "🗑️ Clear ALL History?")
        if [ "$CONFIRM" == "Yes" ]; then
            cliphist wipe
            notify-send "Clipboard" "History Cleared"
        fi
        ;;
    "del")
        # 刪除模式：選什麼刪什麼
        cliphist list | $ROFI_CMD -p "💀 Delete Item" | cliphist delete
        ;;
    *)
        # 預設模式：複製
        # 1. 列出清單
        # 2. 透過 cliphist decode 解碼
        # 3. 透過 wl-copy 放入剪貼簿
        cliphist list | $ROFI_CMD -p " Clipboard" | cliphist decode | wl-copy
        ;;
esac
