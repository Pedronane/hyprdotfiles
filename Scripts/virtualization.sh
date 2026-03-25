#!/bin/bash

set -euo pipefail

log() { printf '\n[+] %s\n' "$*"; }

log "=============================="
log " KVM Setup on Arch/Manjaro"
log "=============================="

# 1. Aggiorna (più leggero)
log "[1/7] Aggiorno pacchetti di base..."
yay -Syu --noconfirm
yay -S --noconfirm archlinux-keyring

# 2. Installa KVM + tools
log "[2/7] Installazione pacchetti KVM..."
yay -S --noconfirm \
  qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils \
  openbsd-netcat dmidecode ebtables libguestfs neovim

# 3. Abilita/libvirtd subito
log "[3/7] Abilito e avvio libvirtd..."
sudo systemctl enable --now libvirtd.service

# 4. Permessi socket + gruppo libvirt
log "[4/7] Configuro permessi libvirt..."
sudo sed -i 's|^#unix_sock_group =.*|unix_sock_group = "libvirt"|' /etc/libvirt/libvirtd.conf
sudo sed -i 's|^#unix_sock_rw_perms =.*|unix_sock_rw_perms = "0770"|' /etc/libvirt/libvirtd.conf

if ! id -nG "$USER" | grep -qw libvirt; then
  log "Aggiungo $USER al gruppo libvirt..."
  sudo usermod -a -G libvirt "$USER"
  echo "⚠️  Per usare virt-manager senza sudo dovrai fare logout/login dopo questo script."
fi

log "Ricarico libvirtd..."
sudo systemctl restart libvirtd.service

# 5. Nested virtualization (opzionale, ma subito attiva)
read -rp "[5/7] Abilitare nested virtualization? [y/n]: " enable_nested

if [[ "$enable_nested" =~ ^[Yy]$ ]]; then
  read -rp "CPU Intel o AMD? [intel/amd]: " cpu_type
  cpu_type=$(echo "$cpu_type" | tr '[:upper:]' '[:lower:]')

  if [[ "$cpu_type" == "intel" ]]; then
    log "Abilito nested virtualization per Intel..."
    sudo modprobe -r kvm_intel || true
    sudo modprobe kvm_intel nested=1
    echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf >/dev/null
  elif [[ "$cpu_type" == "amd" ]]; then
    log "Abilito nested virtualization per AMD..."
    sudo modprobe -r kvm_amd || true
    sudo modprobe kvm_amd nested=1
    echo "options kvm-amd nested=1" | sudo tee /etc/modprobe.d/kvm-amd.conf >/dev/null
  else
    echo "Tipo di CPU non riconosciuto, salto nested virtualization."
  fi
fi

# 6. Rete NAT di default
log "[6/7] Controllo rete NAT 'default'..."

if ! sudo virsh net-info default &>/dev/null; then
  log "Rete 'default' non definita, la creo..."
  sudo virsh net-define /usr/share/libvirt/networks/default.xml
fi

if ! sudo virsh net-list --all | grep -qE '^ default '; then
  log "Avvio rete 'default'..."
  sudo virsh net-start default
fi

if ! sudo virsh net-list --all | grep -qE '^ default .*autostart'; then
  log "Imposto autostart per rete 'default'..."
  sudo virsh net-autostart default
fi

# 7. Check finale
log "[7/7] Controlli finali..."

echo "==> Stato libvirtd:"
systemctl status libvirtd.service --no-pager

if [[ "$enable_nested" =~ ^[Yy]$ ]]; then
  echo "==> Stato nested virtualization:"
  if [[ "$cpu_type" == "intel" ]]; then
    cat /sys/module/kvm_intel/parameters/nested 2>/dev/null || true
  elif [[ "$cpu_type" == "amd" ]]; then
    cat /sys/module/kvm_amd/parameters/nested 2>/dev/null || true
  fi
fi

echo
echo "✅ Setup KVM completato."
echo "Puoi usare subito virt-manager (se sei nel gruppo libvirt)."
echo "Se ti ho appena aggiunto al gruppo libvirt, fai un logout/login per evitare di usare sudo."
