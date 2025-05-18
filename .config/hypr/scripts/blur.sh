#!/usr/bin/env bash

PASSES=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${PASSES}" == "7" ]; then
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:active_opacity 0.65
    hyprctl keyword decoration:inactive_opacity 0.7
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 0
elif [ "${PASSES}" == "0" ]; then
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 3
else
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:blur:size 0
    hyprctl keyword decoration:blur:passes 7
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
fi

