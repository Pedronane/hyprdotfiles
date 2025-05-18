#!/bin/bash

cd $HOME
mkdir Pictures Documents Desktop Projects Scripts Pictures/Screenshots
cd -

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd -
rm -rf yay

# Install compositor and utilities
yay --noconfirm -S hyprland waybar wofi swaync-client imv python-pywalfox hypridle hyprpicker hyprlock grimblast wlogout brightnessctl nwg-look blueman bluez cliphist libnotify xdg-desktop-portal-hyprland hyprpolkitagent nerd-fonts qt5-wayland qt6-wayland network-manager-applet pipewire pipewire-pulse pipewire-alsa pipewire-jack pwvucontrol pavucontrol pulsemixer pywal swww thunar zen-browser-bin ntfs-3g 

# Install terminal stuff
yay --noconfirm -S starship neovim fd cava stow tmux zsh kitty yazi ripgrep fzf bat zoxide unzip fastfetch

# Generate pywal colors and set wallpaper
wal -i $HOME/Pictures/wallpapers/Frieren-Dead-Stare.png

# Enable bluetooth and audio
sudo systemctl enable bluetooth
systemctl --user enable pipewire.service pipewire-pulse.service
systemctl --user start pipewire.service pipewire-pulse.service

# Change shell
chsh -s /usr/bin/zsh

#Copy dotfiles
stow .
