#!/bin/bash

############################################################################################################
########################   ARCH OS ROOT USER  ##############################################################
############################################################################################################


hostname=evdev
############################################################################################################
############################   LANGUAGE AND LOCAL  #########################################################
############################################################################################################
timedatectl --no-ask-password set-ntp 1
sed -i 's/^#hu_HU.UTF-8 UTF-8/hu_HU.UTF-8 UTF-8/g' /etc/locale.gen #uncomment line in file 
sed -i 's/^#hu_HU ISO-8859-2/hu_HU ISO-8859-2/g' /etc/locale.gen #uncomment line in file 
locale-gen
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime

############################################################################################################
############################   KEYBOARD AND FONT  ##########################################################
############################################################################################################
echo "KEYMAP=uk" > /etc/vconsole.conf
echo "FONT=Hack NF" >> /etc/vconsole.conf

############################################################################################################
####################################   NETWORK   ###########################################################
############################################################################################################

echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
echo "$hostname" > /etc/hostname

############################################################################################################
####################################   PACMAN   ############################################################
############################################################################################################
#echo "ILoveCandy" >> /etc/pacman.conf #wrong line 
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector archlinux-keyring
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak #CREATE A BACKUP FROM MIRRORLIST JUST IN CASE 

#ENABLE PASSWORDLESS SUDO
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
#ADD PARALEL DOWNLOADING
sed -i 's/^#Para/Para/g' /etc/pacman.conf
#Enable multilib
#sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Sy --noconfirm

############################################################################################################
############################################################################################################
#GET INFO FROM CPU #TODO
nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "-------------------------------------------------"
echo "Changing the makeflags for "$nc" cores."
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$nc"/g' /etc/makepkg.conf
echo "Changing the compression settings for "$nc" cores."
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g' /etc/makepkg.conf
############################################################################################################

PKGS=(
###########################
#######   BASE   ##########
###########################
'base'                                               # Minimal package set to define a basic Arch Linux installation
'base-devel'
'linux'                                              # The Linux kernel and modules
'linux-firmware'                                     # Firmware files for Linux
'linux-headers'                                      # Headers and scripts for building modules for the Linux kernel
'linux-zen'                                          # The Linux ZEN kernel and modules
'linux-zen-headers'                                  # Headers and scripts for building modules for the Linux ZEN kernel
'networkmanager'                                     # Network connection manager and user applications
'network-manager-applet'
'os-prober' 
'pipewire'
'pipewire-alsa'
'pipewire-pulse'
'pipewire-jack'
'pavucontrol'
'wireplumber'
'pamixer'
###########################
####   Programing     #####
###########################
'git'                                                # the fast distributed version control system
'jq'
'clang'
'npm'
'python'
'rustup'
'go'
'nodejs'
###########################
### Basic Applications ####
###########################
'bash'                                               # The GNU Bourne Again shell'bash-completion'                                    # Programmable completion for the bash shell
'man-db'                                             # Man page
'wget'                                               # Network utility to retrieve files from the Web
'curl'                                               # An URL retrieval utility and library
'unzip'
'zsh'
'stow'
'kitty'
'neovim'
'exa'
'openssh'                                            # Premier connectivity tool for remote login with the SSH protocol
'btop'                                               # Interactive process viewer
'firefox'
'ffmpeg'                                             # Complete solution to record, convert and stream audio and video
'ffmpegthumbnailer'                                  # Lightweight video thumbnailer that can be used by file managers.
'noto-fonts-cjk' # japanese chars
'noto-fonts-emoji' # japanese chars
'noto-fonts' # japanese chars
'cups'                                              #printer service 
'thunar'
'thunar-volman'
'thunar-archive-plugin'
'gvfs'
'gvfs-smb'
'gvfs-mtp'
'sshfs'
'tumbler'
'feh'
'ripgrep'
###########################
####   Applications   #####
###########################
'powertop'
'picom'
'syncthing'
'swaybar'
'bitwarden'
'wofi'
'discord'
'playerctl'
#'polkit-gnome'
#'gnome-control-center'
#'file-roller'
#'xdg-user-dirs'
#'wf-recorder'
#'dbus-python'
#'python-gobject'
#'python-requests'
#'python-jinja'
#'zenity'
#'socat'
#'zenity'
#'socat'
#'xdg-desktop-portal-hyprland'
#'xorg-xwayland'
#'qt5-wayland'
#'qt6-wayland'
#'qt5ct'
#'qt6ct'
#'libva'
#'sshfs'
#'gvfs-mtp'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --needed --noconfirm
done

# determine processor type and install microcode
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

############################################################################################################
################################   BOOT LOADER   ###########################################################
############################################################################################################
pacman -S limine --noconfirm
mkdir -p /boot/EFI/BOOT
cp /usr/share/limine/BOOTX64.EFI

UUID=$(blkid /dev/sda2 | grep UUID | cut -d '"' -f 4)
sed -i "s/XXXXXXXXXXXXXXX/$UUID/" /boot/limine.cfg

############################################################################################################
########################   UPDATE FSTAB  ###################################################################
############################################################################################################
# Behemoth servers
echo "//behemoth.local/server 	/mnt/server     cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab
echo "//behemoth.local/dev    	/mnt/dev        cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab
echo "//behemoth.local/media  	/mnt/media      cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab
echo "//behemoth.local/novels 	/mnt/novels     cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab
echo "//behemoth.local/torrent 	/mnt/torrent   	cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab
echo "//behemoth.local/games  	/mnt/games      cifs            username=erik,pass=Behemetara987321654,rw	0 0" >> /etc/fstab

############################################################################################################
########################   CREATE USER   ###################################################################
############################################################################################################
echo "CREATING USER"
echo "Change root password:"
passwd

if ! source /root/user.conf; then
	read -p "Please enter username:" username
    echo "username=$username" >> /root/user.conf
fi
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel -s /bin/bash $username 
	echo "Change $username password:"
	passwd $username
else
	echo "You are already a user proceed with aur installs"
fi

case "$choice" in
    a|A)
		echo "Automatic ROOT password and user creatin WIP."
		echo "############################################################################################################"
		echo "######################## Automatic ROOT password and user creatin WIP ######################################"
		echo "############################################################################################################"
		sleep 10
      	;;

    b|B)
		echo "You chose option B."
      	;;

    c|C)
        echo "You chose option C."
        ;;

    d|D)
        echo "You chose option D."
        ;;

    *)
        echo "Invalid choice. Please choose a, b, c, or d."
        ;;
esac

cp /root/2.sh /home/$username/

echo "###########################"
echo "### Stage 1 completed #####"
echo "###########################"