#!/bin/bash
PROFILE=$(asusctl profile get | grep "Active profile" | awk '{print $NF}')

if [ "$PROFILE" == "Quiet" ] || [ "$PROFILE" == "Silent" ]; then
    TEXT="󰒲"
elif [ "$PROFILE" == "Performance" ]; then
    TEXT=""
else
    TEXT="⚖️"
fi

CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_INT=$(printf "%.0f" $CPU_LOAD)

if [ "$CPU_INT" -ge 80 ]; then
    CLASS="critical"
elif [ "$CPU_INT" -ge 50 ]; then
    CLASS="warning"
elif [ "$CPU_INT" -ge 30 ]; then
    CLASS="good"
else
    CLASS="normal"
fi

echo "{\"text\": \"$TEXT\", \"tooltip\": \"Mode: $PROFILE\nCPU: $CPU_INT%\", \"class\": \"$CLASS\"}"
