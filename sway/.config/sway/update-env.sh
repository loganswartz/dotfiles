#!/bin/bash

systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME

# Import the WAYLAND_DISPLAY env var from sway into the systemd user session.
dbus-update-activation-environment --all XDG_CURRENT_DESKTOP=sway

# Unlock the gnome keyring
gnome-keyring-daemon --start --components=secrets

# Stop any services that are running, so that they receive the new env var when they restart.
systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start wireplumber
