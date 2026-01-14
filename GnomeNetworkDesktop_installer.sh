#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


echo -e "${GREEN}[1/5] Verificando soporte de hardware...${NC}"
if nmcli device | grep -q "p2p"; then
    echo -e "${BLUE}¡Éxito! Se detectó soporte para Wi-Fi P2P en tu hardware.${NC}"
else
    echo -e "\033[0;31mAdvertencia: No se detectó interfaz Wi-Fi P2P. Miracast podría no funcionar en esta tarjeta de red.${NC}"
fi


echo -e "${BLUE}--- Iniciando instalación de GNOME Network Displays para Pop!_OS ---${NC}"


echo -e "${GREEN}[2/5] Instalando dependencias del sistema y portales...${NC}"
sudo apt update
sudo apt install -y xdg-desktop-portal-cosmic xdg-desktop-portal-gnome ufw flatpak

echo -e "${GREEN}[3/5] Instalando GNOME Network Displays vía Flatpak...${NC}"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.gnome.NetworkDisplays

echo -e "${GREEN}[4/5] Configurando permisos de aislamiento (Sandboxing)...${NC}"
sudo flatpak override org.gnome.NetworkDisplays --socket=wayland --socket=fallback-x11 --device=all --filesystem=xdg-run/pipewire-0

echo -e "${GREEN}[5/5] Configurando puertos en el firewall (UFW)...${NC}"
sudo ufw allow 7236/tcp comment 'Miracast Control'
sudo ufw allow 7250/tcp comment 'Miracast Signaling'
sudo ufw allow 1900/udp comment 'SSDP Discovery'
sudo ufw allow 5353/udp comment 'mDNS/Avahi'
sudo ufw reload

echo -e "${BLUE}--- Proceso finalizado. Reinicia tu sesión para aplicar cambios de Wayland ---${NC}"
