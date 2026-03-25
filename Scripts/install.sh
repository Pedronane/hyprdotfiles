#!/bin/bash
set -euo pipefail

# === Helpers ===
log() { printf '\n[+] %s\n' "$*"; }
err() { printf '\n[!] %s\n' "$*" >&2; }

# === Directory base ===
log "Creo directory base (se non esistono)..."
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Documents" "$HOME/Scripts"

# === Installazione yay (se manca) ===
if ! command -v yay >/dev/null 2>&1; then
  log "Installo yay..."
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  cd "$tmpdir/yay"
  makepkg -si --noconfirm
  cd -
  rm -rf "$tmpdir"
else
  log "yay è già installato, salto."
fi

# === Wallpapers ===
if [ ! -d "$HOME/Pictures/Wallpapers" ]; then
  log "Clono wallpapers..."
  git clone https://github.com/Pedronane/Wallpapers "$HOME/Pictures/Wallpapers"
else
  log "Cartella Wallpapers già presente, salto clone."
fi

# === Pacchetti principali (Hyprland + utilities) ===
log "Installo Hyprland e utilities..."
yay --noconfirm -S \
  hyprland waybar papirus-icon-theme wofi network-manager-applet nautilus \
  swaync-client imv hypridle hyprpicker hyprlock grimblast wlogout \
  brightnessctl nwg-look blueman bluez cliphist libnotify \
  xdg-desktop-portal-hyprland hyprpolkitagent maplemono-nf-cn \
  qt5-wayland qt6-wayland pipewire pipewire-pulse pipewire-alsa \
  pipewire-jack pulsemixer pywal awww zen-browser-bin ntfs-3g \
  zathura zathura-pdf-mupdf sddm wlsunset python-pywalfox \
  noto-fonts-emoji torbrowser-launcher

# === Pacchetti terminale ===
log "Installo tool da terminale..."
yay --noconfirm -S \
  starship neovim fd cava stow tmux zsh kitty yazi ripgrep fzf \
  bat zoxide unzip fastfetch yarn man-db

# === Servizi bluetooth e audio ===
log "Abilito servizi bluetooth e audio..."
sudo systemctl enable bluetooth
systemctl --user enable pipewire.service pipewire-pulse.service || true
systemctl --user start  pipewire.service pipewire-pulse.service || true

# === Pywalfox ===
log "Installo pywalfox..."
pywalfox install || err "pywalfox install è fallito (controlla Firefox/Zen)."

# === Display manager ===
log "Abilito sddm..."
sudo systemctl enable sddm.service

# === Zathura default ===
log "Imposto Zathura come pdf viewer di default..."
xdg-mime default org.pwmt.zathura.desktop application/pdf || true

# === Shell di default ===
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  log "Cambio shell di default in zsh..."
  chsh -s /usr/bin/zsh
else
  log "zsh è già la shell di default."
fi

# === Stow dotfiles ===
log "Applico dotfiles con stow..."
cd "$HOME"
stow . || err "Stow ha dato errore, controlla i conflitti di file."
cd -

# === swww + wal ===
log "Avvio swww-daemon..."
swww-daemon &

if [ -f "$HOME/Pictures/Wallpapers/dark-academia-1.jpeg" ]; then
  log "Genero colori con wal..."
  wal -i "$HOME/Pictures/Wallpapers/dark-academia-1.jpeg"
else
  err "Wallpaper dark-academia-1.jpeg non trovato, salto wal."
fi

# === Pulizia tmux plugins (fix path) ===
log "Pulisco cartella tmux plugins..."
rm -rf "$HOME/.config/tmux/plugins/"* 2>/dev/null || true

cd "$HOME"

# === Tema SDDM ===
log "Installo tema SDDM SilentSDDM..."
tmp_sddm="$(mktemp -d)"
git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM "$tmp_sddm/SilentSDDM"
cd "$tmp_sddm/SilentSDDM"
./install.sh
cd -
rm -rf "$tmp_sddm"

# === Tema GRUB ===
log "Installo tema GRUB Elegant..."
yay -S --noconfirm os-prober lsb-release
tmp_grub="$(mktemp -d)"
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git "$tmp_grub/Elegant-grub2-themes"
cd "$tmp_grub/Elegant-grub2-themes"
./install.sh -t mojave -p blur -i right -c dark -l system
cd -
rm -rf "$tmp_grub"

log "Installazione completata. Riavvia per usare Hyprland."
