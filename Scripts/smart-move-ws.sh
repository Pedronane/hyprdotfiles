#!/bin/bash

KEY="$1"

# Get the active workspace
ACTIVE_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Find the monitor associated with that workspace
ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r --arg ws "$ACTIVE_WS" '.[] | select(.activeWorkspace.id == ($ws|tonumber)) | .name')

# Sort monitors with priority: eDP < DP < HDMI < others
readarray -t MONITORS < <(
  hyprctl monitors -j | jq -r '.[].name' |
  awk '
    /eDP/ { print "1 " $0; next }
    /^DP/ { print "2 " $0; next }
    /^HDMI/ { print "3 " $0; next }
    { print "4 " $0 }
  ' | sort | cut -d' ' -f2
)

# Find the index of the active monitor in the sorted list
for i in "${!MONITORS[@]}"; do
  if [[ "${MONITORS[$i]}" == "$ACTIVE_MONITOR" ]]; then
    MON_INDEX=$i
    break
  fi
done

# Default to 0 if MON_INDEX is not set
MON_INDEX=${MON_INDEX:-0}

# Calculate the target workspace
WS=$(( KEY + MON_INDEX * 10 ))

# Move the active window to the calculated workspace
hyprctl dispatch movetoworkspace "$WS"
