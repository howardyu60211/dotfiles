#!/bin/bash

# --- 設定 ---
# 確保你有安裝對應的字體 (Font Awesome / Nerd Fonts)
ICON_BT=""
ICON_ON=""
ICON_OFF=""
ICON_CONNECT=""
ICON_DISCONNECT=""

# --- 獲取藍牙狀態 ---
POWER_STATE=$(bluetoothctl show | grep "Powered: yes" | wc -l)

# --- 定義主選單 ---
if [ "$POWER_STATE" -eq 1 ]; then
    # 如果藍牙是開的
    TITLE="Bluetooth: ON"
    OPTION_POWER="$ICON_ON  Turn Off Bluetooth"

    # 獲取已配對的裝置列表
    # 格式: "MAC地址 DeviceName" -> 轉換顯示為 "DeviceName"
    DEVICES=$(bluetoothctl devices | cut -d ' ' -f 3-)
else
    # 如果藍牙是關的
    TITLE="Bluetooth: OFF"
    OPTION_POWER="$ICON_OFF  Turn On Bluetooth"
    DEVICES=""
fi

# --- 組合 Rofi 選項 ---
# 顯示順序：開關 -> 分隔線 -> 裝置列表
if [ -n "$DEVICES" ]; then
    OPTIONS="$OPTION_POWER\n$DEVICES"
else
    OPTIONS="$OPTION_POWER"
fi

# --- 顯示 Rofi ---
SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "$ICON_BT  Bluetooth" -theme-str 'window {width: 400px;}')

# --- 處理選擇 ---
case "$SELECTED" in
    "")
        exit 0
        ;;
    "$OPTION_POWER")
        if [ "$POWER_STATE" -eq 1 ]; then
            bluetoothctl power off
            notify-send "Bluetooth" "Powered OFF"
        else
            bluetoothctl power on
            notify-send "Bluetooth" "Powered ON"
        fi
        ;;
    *)
        # 處理裝置連接/斷線
        # 1. 根據名稱找回 MAC 地址
        DEVICE_NAME="$SELECTED"
        MAC=$(bluetoothctl devices | grep "$DEVICE_NAME" | cut -d ' ' -f 2)

        if [ -n "$MAC" ]; then
            # 檢查目前是否連線中
            IS_CONNECTED=$(bluetoothctl info "$MAC" | grep "Connected: yes" | wc -l)

            if [ "$IS_CONNECTED" -eq 1 ]; then
                bluetoothctl disconnect "$MAC"
                notify-send "Bluetooth" "Disconnected from $DEVICE_NAME"
            else
                notify-send "Bluetooth" "Connecting to $DEVICE_NAME..."
                bluetoothctl connect "$MAC"
                if [ $? -eq 0 ]; then
                     notify-send "Bluetooth" "Connected to $DEVICE_NAME"
                else
                     notify-send "Bluetooth" "Connection Failed"
                fi
            fi
        fi
        ;;
esac
