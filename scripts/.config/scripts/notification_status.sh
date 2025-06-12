#!/bin/bash

# First, check if the swaync-client command exists.
if ! command -v swaync-client &> /dev/null; then
    echo "{}" # Output empty JSON to hide module if swaync isn't installed.
    exit 0
fi

# Get the notification counts, hiding any potential errors.
count=$(swaync-client -c 2>/dev/null)
critical_count=$(swaync-client -C 2>/dev/null)

# Default counts to 0 if the commands failed (e.g., swaync daemon not running).
if [ -z "$count" ]; then
    count=0
fi
if [ -z "$critical_count" ]; then
    critical_count=0
fi

# Use the solid bell icon
icon=""

# Default text shows the count and the icon
text="$count $icon"

# Prioritize showing the critical count if it's greater than zero
if [ "$critical_count" -gt 0 ]; then
    text="$critical_count $icon"
    class="notifications-critical"
else
    class="notifications"
fi

# If there are no notifications at all, just show the icon without a number.
if [ "$count" -eq 0 ]; then
    text="$icon"
fi

tooltip="Notifications: $count\nCritical: $critical_count"

# Final JSON output, with the -c flag for single-line compact output
jq -c -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
   '{text: $text, tooltip: $tooltip, class: $class}'