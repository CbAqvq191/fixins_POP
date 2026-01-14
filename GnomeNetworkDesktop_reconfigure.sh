#!/bin/bash

# 1. Reconfigurando Permisos de Flatpak para Sandboxing
sudo flatpak override org.gnome.NetworkDisplays --socket=wayland --socket=fallback-x11 --device=all --filesystem=xdg-run/pipewire-0

# 2. Reconfigurando el Firewall (UFW)
sudo ufw allow 7236/tcp comment 'Miracast Control'
sudo ufw allow 7250/tcp comment 'Miracast Signaling'
sudo ufw allow 1900/udp comment 'SSDP Discovery'
sudo ufw allow 5353/udp comment 'mDNS/Avahi'
sudo ufw reload
