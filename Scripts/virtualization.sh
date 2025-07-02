#!/bin/bash

set -e

echo "=============================="
echo " KVM Setup on Arch/Manjaro"
echo "=============================="

# Step 1: Update packages and keyring
echo "[1/8] Updating package database and keyring..."
yay -Syy --noconfirm
yay -Syu --noconfirm
yay -S --noconfirm archlinux-keyring

# Step 2: Install KVM and dependencies
echo "[2/8] Installing KVM packages..."
yay -S --noconfirm qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat dmidecode ebtables libguestfs neovim

# Step 3: Enable and start libvirtd
echo "[3/8] Enabling and starting libvirtd..."
sudo systemctl enable --now libvirtd.service

# Step 4: Configure libvirt socket permissions
echo "[4/8] Setting libvirt socket permissions..."
sudo sed -i 's|^#unix_sock_group =.*|unix_sock_group = "libvirt"|' /etc/libvirt/libvirtd.conf
sudo sed -i 's|^#unix_sock_rw_perms =.*|unix_sock_rw_perms = "0770"|' /etc/libvirt/libvirtd.conf
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt

# Step 5: Restart libvirtd
echo "[5/8] Restarting libvirtd..."
sudo systemctl restart libvirtd.service

# Step 6: Enable nested virtualization (optional)
read -rp "[6/8] Do you want to enable nested virtualization? [y/n]: " enable_nested

if [[ "$enable_nested" =~ ^[Yy]$ ]]; then
    read -rp "Are you using an Intel or AMD CPU? [intel/amd]: " cpu_type
    cpu_type=$(echo "$cpu_type" | tr '[:upper:]' '[:lower:]')

    if [[ "$cpu_type" == "intel" ]]; then
        echo "Setting nested virtualization for Intel..."
        sudo modprobe -r kvm_intel || true
        sudo modprobe kvm_intel nested=1
        echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
    elif [[ "$cpu_type" == "amd" ]]; then
        echo "Setting nested virtualization for AMD..."
        sudo modprobe -r kvm_amd || true
        sudo modprobe kvm_amd nested=1
        echo "options kvm-amd nested=1" | sudo tee /etc/modprobe.d/kvm-amd.conf
    else
        echo "Unknown CPU type. Skipping nested virtualization."
    fi
fi

# Step 7: Setup default NAT network for virtual machines
echo "[7/8] Checking default NAT network..."
if ! sudo virsh net-info default &>/dev/null; then
    echo "Default network not found. Creating..."
    sudo virsh net-define /usr/share/libvirt/networks/default.xml
fi

if ! sudo virsh net-list --all | grep -q default; then
    echo "Defining default NAT network..."
    sudo virsh net-define /usr/share/libvirt/networks/default.xml
fi

if ! sudo virsh net-list --all | grep default | grep -q active; then
    echo "Starting default NAT network..."
    sudo virsh net-start default
fi

if ! sudo virsh net-list --all | grep default | grep -q autostart; then
    echo "Enabling autostart for default NAT network..."
    sudo virsh net-autostart default
fi

# Step 8: Final status check
echo "[8/8] Final system checks..."

echo "==> libvirtd service status:"
systemctl status libvirtd.service --no-pager

if [[ "$enable_nested" =~ ^[Yy]$ ]]; then
    echo "==> Nested virtualization status:"
    if [[ "$cpu_type" == "intel" ]]; then
        systool -m kvm_intel -v | grep nested || true
        cat /sys/module/kvm_intel/parameters/nested || true
    elif [[ "$cpu_type" == "amd" ]]; then
        systool -m kvm_amd -v | grep nested || true
        cat /sys/module/kvm_amd/parameters/nested || true
    fi
fi

echo "✅ KVM and default NAT network setup complete!"
echo "Reboot your system to apply all changes."
