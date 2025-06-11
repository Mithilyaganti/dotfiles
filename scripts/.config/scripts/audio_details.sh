#!/usr/bin/env bash
# audio_details.sh for Waybar
exec 2>>"$HOME/.cache/waybar-audio.log"

emit_empty() {
    printf '{"text": "", "tooltip": ""}\n'
    exit 0
}

if ! command -v pactl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    emit_empty
fi

DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null || pactl info 2>/dev/null | awk -F': ' '/Default Sink:/{print $2}')
if [ -z "$DEFAULT_SINK" ]; then
    emit_empty
fi

pactl_out=$(pactl list sinks 2>/dev/null)
if [ -z "$pactl_out" ]; then
    emit_empty
fi

info=$(printf '%s\n' "$pactl_out" | grep -A 30 -F "Name: $DEFAULT_SINK")
if [ -z "$info" ]; then
    emit_empty
fi

VOLUME=$(printf '%s\n' "$info" | awk '/Volume:/{for(i=1;i<=NF;i++)if($i~/%/){gsub(/[^0-9]/,"",$i);print i==""?0:$i;exit}}' | head -n1)
if ! [[ "$VOLUME" =~ ^[0-9]+$ ]]; then
    VOLUME=0
fi

MUTE=$(printf '%s\n' "$info" | awk '/Mute:/{print $2; exit}')
if [ "$MUTE" = "yes" ]; then
    ICON=""
else
    if [ "$VOLUME" -eq 0 ]; then
        ICON=""
    elif [ "$VOLUME" -lt 50 ]; then
        ICON=""
    else
        ICON=""
    fi
fi

TOOLTIP=$(printf '%s\n' "$pactl_out" | awk '/Description:/{desc=substr($0,index($0,$2))} /Volume:/{for(i=1;i<=NF;i++)if($i~/%/){vol=$i;gsub(/[^0-9%]/,"",vol);if(desc!="")printf"%s: %s\n",desc,vol;break}}' | sed 's/^[ \t]*//;s/[ \t]*$//')
if [ -z "$TOOLTIP" ]; then
    TOOLTIP=""
fi

# *** THE CORRECTED LINE WITH THE -c FLAG ***
# The -c flag ensures the JSON is on a single line.
jq -c -n --arg icon "$ICON" --arg text "${VOLUME}%" --arg tooltip "$TOOLTIP" \
   '{text: $icon + " " + $text, tooltip: $tooltip}'