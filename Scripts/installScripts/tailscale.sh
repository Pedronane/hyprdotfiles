#!/bin/bash

yay -S --noconfirm tailscale

sudo systemctl enable tailscaled.service
sudo systemctl start tailscaled.service

sudo tailscale up
