#!/bin/bash
set -x

devices=$(lsblk -o NAME,RM,TYPE,SIZE,MODEL -nr | awk '$2 == 1 && $3 == "part" {print "/dev/" $1 " - " $4 " - " $5}')

selected=$(echo "$devices" | wofi --dmenu --prompt "Select a USB drive to mount")

[ -z "$selected" ] && exit 1

device=$(echo "$selected" | awk '{print $1}')

mount_location=$(echo -e "$HOME/Media\n/mnt" | wofi --dmenu --prompt "Mount location?")

[ -z "$mount_location" ] && exit 1

mount_point="$mount_location/usb-$(basename "$device")"

sudo mkdir -p "$mount_point"

if mount | grep -q "$device"; then
    sudo umount "$device" "$mount_point" && \
    notify-send "USB unmounted" "$device unmounted" || \
    notify-send "Error" "Failed to unmount $device"
else
    sudo mount "$device" "$mount_point" && \
    notify-send "USB mounted" "$device mounted at $mount_point" || \
    notify-send "Error" "Failed to mount $device"
fi
