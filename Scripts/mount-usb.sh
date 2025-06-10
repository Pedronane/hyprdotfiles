#!/bin/bash

# Ottieni la lista delle USB collegate usando lsblk e filtra solo i dispositivi rimovibili (RM=1)
devices=$(lsblk -o NAME,RM,SIZE,MODEL,MOUNTPOINT -nr | awk '$2 == 1 {print "/dev/" $1 " - " $3 " - " $4}')

# Mostra la lista con wofi
selected=$(echo "$devices" | wofi --dmenu --prompt "Seleziona una USB da montare")

# Controlla se l'utente ha annullato
[ -z "$selected" ] && exit 1

# Estrai il nome del dispositivo (es. /dev/sdb1)
device=$(echo "$selected" | awk '{print $1}')

# Controlla se il dispositivo ha partizioni
if [[ ! -b "$device" ]]; then
    notify-send "Errore" "Dispositivo non valido: $device"
    exit 1
fi

# Crea una cartella di mount se non esiste
mount_point="/mnt/usb-$(basename "$device")"
sudo mkdir -p "$mount_point"

# Monta il dispositivo
if mount | grep -q "$device"; then
    notify-send "USB già montata" "$device è già montato."
else
    sudo mount "$device" "$mount_point" && \
    notify-send "USB montata" "$device montato in $mount_point" || \
    notify-send "Errore" "Impossibile montare $device"
fi
