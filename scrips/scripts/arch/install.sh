#!/bin/bash

# Set the target disk (change /dev/sdX to your actual disk)
TARGET_DISK="/dev/sda"

# Partition the disk
parted "$TARGET_DISK" mklabel gpt
parted "$TARGET_DISK" mkpart primary ext4 1MiB 512MiB  # Boot partition
parted "$TARGET_DISK" set 1 boot on
parted "$TARGET_DISK" mkpart primary linux-swap 512MiB 8.5GiB  # Swap partition
parted "$TARGET_DISK" mkpart primary ext4 8.5GiB 100%  # Linux filesystem partition

# Format partitions
mkfs.ext4 "${TARGET_DISK}1"  # Boot partition
mkswap "${TARGET_DISK}2"     # Swap partition
mkfs.ext4 "${TARGET_DISK}3"  # Linux filesystem partition

# Mount partitions
mount "${TARGET_DISK}3" /mnt
mkdir /mnt/boot
mount "${TARGET_DISK}1" /mnt/boot
swapon "${TARGET_DISK}2"

# Install base system
pacstrap /mnt base base-devel

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt

echo "Password for root"
passwd
# Set the hostname
echo "evdev" > /etc/hostname

# Configure locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set the timezone
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime

# Install Limine bootloader
pacman -S limine
limine-install /dev/sda  # Install Limine to the disk

# Create a user
useradd -m -G wheel erik
echo "Password for user"
passwd erik

# Enable necessary services (e.g., NetworkManager)
systemctl enable NetworkManager

sudo pacman -S git neovim btop powertop stow syncthing zsh exa swaybar bitwarden wofi firefox discord thunar thunar-volman gvfs gvfs-smb gvfs-mtp sshfs tumbler feh pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol wireplumber ripgrep network-manager-applet playerctl jq polkit-gnome pamixer gnome-control-center thunar-archive-plugin file-roller xdg-user-dirs wf-recorder dbus-python python-gobject python-requests python-jinja zenity socat clang npm unzip gvfs-smb kitty 
sudo pacman -S xdg-desktop-portal-hyprland xorg-xwayland qt5-wayland qt6-wayland qt5ct qt6ct libva linux-headers
sudo pacman -S ripgrep playerctl
sudo pacman -S zenity socat
# JAPANESE characters
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts

pacman -S sshfs gvfs-mtp thunar-volman
sudo pacman -S cdrtools cdrdao
sudo modprobe cifs

#YAY install
cd ~/temp/
git clone https://aur.archlinux.org/yay.git 
cd yay 
makepkg -si PKGBUILD
cd ~/temp/
rm -r yay

yay -S gradience-git adw-gtk3-git eww-tray-wayland-git swww grimblast-git python-material-color-utilities hyprpicker-git

# Fonts and icons
yay -S ttf-jetbrains-mono ttf-nerd-fonts-symbols papirus-icon-theme
#Set up fonst and icons
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
gsettings set org.gnome.desktop.interface icon-theme Papirus
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono Regular 11"

# Exit chroot
exit

# Unmount partitions
umount -R /mnt
reboot