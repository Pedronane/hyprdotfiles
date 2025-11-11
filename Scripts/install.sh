#!/bin/bash

cd $HOME
mkdir Pictures Documents Scripts Pictures/Screenshots
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
yay --noconfirm -S hyprland waybar papirus-icon-theme wofi network-manager-applet nautilus swaync-client imv hypridle hyprpicker hyprlock grimblast wlogout brightnessctl nwg-look blueman bluez cliphist libnotify xdg-desktop-portal-hyprland hyprpolkitagent maplemono-nf-cn qt5-wayland qt6-wayland pipewire pipewire-pulse pipewire-alsa pipewire-jack pulsemixer pywal swww zen-browser-bin ntfs-3g zathura zathura-pdf-mupdf sddm wlsunset python-pywalfox noto-fonts-emoji torbrowser-launcher

# Install terminal stuff
yay --noconfirm -S starship neovim fd cava stow tmux zsh kitty yazi ripgrep fzf bat zoxide unzip fastfetch yarn man-db

# Enable bluetooth and audio
sudo systemctl enable bluetooth
systemctl --user enable pipewire.service pipewire-pulse.service
systemctl --user start pipewire.service pipewire-pulse.service

# Install pywalfox
pywalfox install

# Enable display manager
sudo systemctl enable sddm.service

# Make Zathura default pdf viewer
xdg-mime default org.pwmt.zathura.desktop application/pdf

# Change shell
chsh -s /usr/bin/zsh

# Copy dotfiles
stow .

# Start swww daemon
swww-daemon &

# Generate pywal colors and set wallpaper
wal -i $HOME/Pictures/Wallpapers/dark-academia-1.jpeg

# Remove empty tmux plugins folders
rm -rf $HOME/.confing/tmux/plugins/*

cd $HOME

# Install sddm theme
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM && cd SilentSDDM && ./install.sh
cd -
rm -rf SilentSDDM

# Install grub theme
yay -S --noconfirm os-prober lsb-releas
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git
cd Elegant-grub2-themes
./install.sh -t mojave -p blur -i right -c dark -l system
cd -
rm -rf Elegant-grub2-themes

Hyrpland
