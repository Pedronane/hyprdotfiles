#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

menu() {
    fd . "$WALLPAPER_DIR" -d 1 -e jpg -e jpeg -e png -e gif -t f --exclude currentwallpaper.jpg | awk '{print "img:"$0}'
}

main() {
  choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
  [[ -z "$choice" ]] && exit 0

  selected_wallpaper=$(echo "$choice" | sed 's/^img://')

  swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
  wal -i "$selected_wallpaper" -n --cols16

  cp ~/.cache/wal/obsidian.css ~/Appunti/.obsidian/snippets
  swaync-client --reload-css
  ~/.config/waybar/refresh.sh
  cat ~/.cache/wal/colors-kitty.conf >~/.config/kitty/current-theme.conf

  color1=$(awk 'match($0, /color2=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  color2=$(awk 'match($0, /color3=\47(.*)\47/,a) { print a[1] }' ~/.cache/wal/colors.sh)
  cava_config="$HOME/.config/cava/config"
  sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $cava_config
  sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $cava_config
  pkill -USR2 cava || cava -p $cava_config

  source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/wallpapers/currentwallpaper.jpg 
}

main

