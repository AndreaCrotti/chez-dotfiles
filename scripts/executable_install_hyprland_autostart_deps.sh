#!/usr/bin/env bash
set -euo pipefail

# Install the packages backing the programs launched from the
# AUTOSTART section of dot_config/hypr/hyprland.lua.

OFFICIAL_PKGS=(waybar swaync hyprpaper hypridle network-manager-applet nwg-dock-hyprland)
AUR_PKGS=(dropbox)

if command -v aura &>/dev/null; then
    sudo aura -S --needed "${OFFICIAL_PKGS[@]}"
    sudo aura -A --needed "${AUR_PKGS[@]}"
else
    sudo pacman -S --needed "${OFFICIAL_PKGS[@]}"
    echo "aura not found: install an AUR helper to get ${AUR_PKGS[*]}, or install manually." >&2
fi
