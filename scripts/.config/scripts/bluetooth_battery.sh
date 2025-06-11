#!/bin/bash

# Find connected bluetooth devices
devices=$(bluetoothctl devices Connected | cut -f2 -d' ')

# If no devices are connected, output empty JSON and exit.
if [ -z "$devices" ]; then
    echo "{}"
    exit 0
fi

text_output=""
tooltip_output=""

for mac_address in $devices; do
    info=$(bluetoothctl info "$mac_address")
    name=$(echo "$info" | grep "Name:" | cut -d' ' -f2-)

    # *** THE FIX IS IN THIS LINE ***
    # We now use awk to grab the 4th field (the decimal value) and remove the parentheses.
    battery=$(echo "$info" | awk '/Battery Percentage:/ {gsub(/[()]/,"",$4); print $4}')

    # Only process if a battery level was actually found
    if [ -n "$battery" ]; then
        text_output+=" ${battery}%  "
        tooltip_output+="${name}: ${battery}%\n"
    fi
done

# After checking all devices, decide what to output.
if [ -n "$text_output" ]; then
    tooltip_output=$(echo -e "$tooltip_output" | sed '/^$/d')
    jq -c -n --arg text "$text_output" --arg tooltip "$tooltip_output" \
        '{text: $text, tooltip: $tooltip}'
else
    # Output empty JSON to hide the module if no devices have battery info.
    echo "{}"
fi