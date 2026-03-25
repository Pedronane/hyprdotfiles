#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

menu() {
    fd . "$WALLPAPER_DIR" -d 1 -e jpg -e jpeg -e png -e gif -t f --exclude currentwallpaper.jpg \
      | awk '{print "img:"$0}'
}

main() {
  choice=$(menu | wofi -c ~/.config/wofi/wallpaper \
                       -s ~/.config/wofi/style-wallpaper.css \
                       --show dmenu \
                       --prompt "Select Wallpaper:" -n)
  [[ -z "$choice" ]] && exit 0

  selected_wallpaper=$(echo "$choice" | sed 's/^img://')

  # cambia wallpaper con awww
  awww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5

  # genera colori con pywal
  wal -i "$selected_wallpaper" -n --cols16

  # Obsidian
  cp ~/.cache/wal/obsidian.css ~/Appunti/.obsidian/snippets

  # swaync
  swaync-client --reload-css

  # waybar
  ~/.config/waybar/refresh.sh

  # kitty
  cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf

  # Xresources
  cat ~/.cache/wal/colors.Xresources > ~/.Xresources

  # GTK4
  mkdir -p ~/.config/gtk-4.0
  cp ~/.cache/wal/colors-gtk-4.0.css ~/.config/gtk-4.0/colors.css

  # ricarica nautilus per i colori
  nautilus -q

  # aggiorna gradient di cava
  color1=$(awk 'match($0, /color2='\''(.*)'\''/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  color2=$(awk 'match($0, /color3='\''(.*)'\''/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  cava_config="$HOME/.config/cava/config"
  sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$cava_config"
  sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$cava_config"
  pkill -USR2 cava || cava -p "$cava_config"

  # salva wallpaper corrente
  mkdir -p "$WALLPAPER_DIR"
  cp "$selected_wallpaper" "$WALLPAPER_DIR/currentwallpaper.jpg"
}

main
