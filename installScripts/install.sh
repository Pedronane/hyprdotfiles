#!/bin/bash

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~/

# Install Compositor and utilities
yay -S hyprland waybar wofi swaync-client sddm uwsm python-pywalfox hypridle hyprpicker hyprshot hyprlock wlogout brightnessctl nwg-look blueman bluez cliphist grim slurp libnotify xdg-desktop-portal-hyprland hyprpolkitagent-bin nerd-fonts qt5-wayland qt6-wayland network-manager-applet pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol pulsemixer pywal swww thunar brave-bin

# Install terminal stuff
yay -S starship neovim fd cava btop stow tmux zsh kitty superfile ripgrep fzf bat zoide


# Generate colors
wal -i ~/dotfiles/wallpapers/Frieren-Dead-Stare.png -n

# Enable some services
sudo systemctl enable bluetooth
sudo systemctl enable sddm.service
systemctl --user enable pipewire.service pipewire-pulse.service
systemctl --user start pipewire.service pipewire-pulse.service

# Change shell
chsh -s /usr/bin/zsh

#Copy dotfiles
cd ~/dotfiles
stow .
