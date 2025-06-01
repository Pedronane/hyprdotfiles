#!/bin/bash

cd $HOME
mkdir Music Pictures Documents Projects Scripts Pictures/Screenshots
cd -

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd -
rm -rf yay

# Copy wallpapers
git clone https://github.com/Pedronane/Wallpapers $HOME/Pictures/Wallpapers

# Install compositor and utilities
yay --noconfirm -S hyprland waybar wofi swaync-client imv hypridle hyprpicker hyprlock grimblast wlogout brightnessctl nwg-look blueman bluez cliphist libnotify xdg-desktop-portal-hyprland hyprpolkitagent ttf-0xproto-nerd otf-codenewroman-nerd qt5-wayland qt6-wayland pipewire pipewire-pulse pipewire-alsa pipewire-jack pulsemixer pywal swww zen-browser-bin ntfs-3g zathura sddm

# Install terminal stuff
yay --noconfirm -S starship neovim fd cava stow tmux zsh kitty yazi ripgrep fzf bat zoxide unzip fastfetch

# Generate pywal colors and set wallpaper
wal -i $HOME/Pictures/Wallpapers/Frieren-Dead-Stare.png

# Enable bluetooth and audio
sudo systemctl enable bluetooth
systemctl --user enable pipewire.service pipewire-pulse.service
systemctl --user start pipewire.service pipewire-pulse.service

# Enable display manager
sudo systemctl enable sddm.service

# Change shell
chsh -s /usr/bin/zsh

# Copy dotfiles
stow .

# Remove empty tmux plugins folders
rm -rf $HOME/.confing/tmux/plugins/*
