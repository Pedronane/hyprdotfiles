#!/usr/bin/env bash

PASSES=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${PASSES}" == "3" ]; then
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 0
else
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 3
fi
