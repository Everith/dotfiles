#!/bin/env bash

sudo pacman -S git neovim btop powertop stow syncthing zsh exa swaybar bitwarden wofi firefox discord thunar thunar-volman gvfs gvfs-smb gvfs-mtp sshfs tumbler feh pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol wireplumber ripgrep network-manager-applet playerctl jq polkit-gnome pamixer gnome-control-center thunar-archive-plugin file-roller xdg-user-dirs wf-recorder dbus-python python-gobject python-requests python-jinja zenity socat clang npm unzip gvfs-smb kitty 
sudo pacman -S xdg-desktop-portal-hyprland xorg-xwayland qt5-wayland qt6-wayland qt5ct qt6ct libva linux-headers
sudo pacman -S ripgrep playerctl
sudo pacman -S zenity socat
# JAPANESE characters
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts

pacman -S sshfs gvfs-mtp thunar-volman
#sudo pacman -S cdrtools cdrdao
sudo modprobe cifs

