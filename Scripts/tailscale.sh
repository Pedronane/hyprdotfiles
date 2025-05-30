#!/bin/bash

yay -S --noconfirm tailscale

sudo systemctl enable tailscaled.service
sudo systemctl start tailscaled.service

sudo tailscale up

sudo tailscale set --exit-node=100.127.236.32
