
############################################################################################################
############################   LANGUAGE AND LOCAL  #########################################################
############################################################################################################
sudo timedatectl --no-ask-password set-ntp 1
sudo sed -i 's/^#hu_HU.UTF-8 UTF-8/hu_HU.UTF-8 UTF-8/' /etc/locale.gen #uncomment line in file 
sudo sed -i 's/^#hu_HU ISO-8859-2/hu_HU ISO-8859-2/' /etc/locale.gen #uncomment line in file 
sudo locale-gen
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime

############################################################################################################
############################   KEYBOARD AND FONT  ##########################################################
############################################################################################################
sudo echo "KEYMAP=uk" > /etc/vconsole.conf
sudo echo "FONT=Hack NF" >> /etc/vconsole.conf

############################################################################################################
####################################   PACMAN   ############################################################
############################################################################################################
sudo pacman -S --noconfirm pacman-contrib curl
sudo pacman -S --noconfirm reflector archlinux-keyring
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak #CREATE A BACKUP FROM MIRRORLIST JUST IN CASE 

#ADD PARALEL DOWNLOADING
sudo sed -i 's/^#Para/Para/' /etc/pacman.conf
#Enable multilib
sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sudo pacman -Sy --noconfirm

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
'bind'                                               # A complete, highly portable implementation of the DNS protocol
'networkmanager'                                     # Network connection manager and user applications
'network-manager-applet'
'dhclient'
'reflector'                                          # pacman mirror manager
'grub'                                               # GNU GRand Unified Bootloader (2)
'efibootmgr'                                         # Linux user-space application to modify the EFI Boot Manager
'make'                                               # GNU make utility to maintain groups of programs
'gcc'                                                # The GNU Compiler Collection - C and C++ frontends
'gcc-libs'                                           # Runtime libraries shipped by GCC
'autoconf'                                           # A GNU tool for automatically configuring source code
'automake'                                           # A GNU tool for automatically creating Makefiles
'xdg-utils'
'xdg-user-dirs'

'os-prober' 
'dialog'

'alsa-utils'                                        # Advanced Linux Sound Architecture - Utilities'openresolv'                                         # resolv.conf management framework (resolvconf)
'alsa-firmware'                                   # Firmware binaries for loader programs in alsa-tools and hotplug firmware loader
'alsa-plugins'                                    # Additional ALSA plugins
'man-db'                                             # Man page
'openssh'                                            # Premier connectivity tool for remote login with the SSH protocol
'git'                                                # the fast distributed version control system
'grub-tools'                                         # Fixes, additions and enhancements to grub and os-prober.
'bash'                                               # The GNU Bourne Again shell
'bash-completion'                                    # Programmable completion for the bash shell
'wget'                                               # Network utility to retrieve files from the Web
'curl'                                               # An URL retrieval utility and library
'htop'                                               # Interactive process viewer
'ffmpeg'                                             # Complete solution to record, convert and stream audio and video
'ffmpegthumbnailer'                                  # Lightweight video thumbnailer that can be used by file managers.
'grub-customizer'
'gamemode'

###########################
#######   LVM   ###########
###########################
#'lvm2'                                               # Logical Volume Manager 2 utilities

###########################
#######   BTRFS   #########
###########################
#'snapper'                                           #btrfs snapshot helper / manager

###########################
#######   XORG   ##########
###########################
'xorg-server'
'xorg-xinit'

###########################
#####   Wayland   #########
###########################


###########################
####   Applications   #####
###########################
'youtube-dl'
'gallery-dl'
'tmux'
'exa' # ls morern colorful variant
'firefox'
'nautilus'
'kitty'
'picom'
'cups'                                              #printer service 
'undistract-me'
'mpv'
'zathura'
'anki'
'calcurse'
'taskbook'
'ranger'
'dolphin'
'imagemagik'
'flameshot'
'libreoffice'
'manuskript'

###########################
###   Display manager   ###
###########################
#'lightdm'
# 'lightdm-gtk-greeter'
# 'lightdm-gtk-greeter-settings'
'sddm'  #plasma login manager or something need to enable sddm.service
# 'ly-git' #aur DM comandline minimal 

########################### wayland
#######   sway   ########## dont support nvidia drivers only opensource drivers
###########################
# 'sway'                                               # Tiling Wayland compositor and replacement for the i3 window manager
# 'swaybg'                                             # Wallpaper tool for Wayland compositors
# 'swayidle'                                           # Idle management daemon for Wayland
# 'swaylock'                                           # Screen locker for Wayland
# 'waybar'                                             # Highly customizable Wayland bar for Sway and Wlroots based compositors

########################## xorg
######   i3-gaps   #######
##########################
'i3-gaps'
'i3lock'
'i3status'
'rofi'

########################### xorg and wayland
#####   kde-plasma   ######
###########################
# 'xorg' 
# 'plasma' 
# 'kde-applications' 
# 'simplescreenrecorder' 
# 'papirus-icon-theme' 
# 'kdenlive' 
# 'materia-kde'

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
		sudo pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		sudo pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    sudo pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    sudo pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    sudo pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

cd ~/dev
git clone "https://aur.archlinux.org/yay.git"
cd ~/dev/yay
makepkg -si --noconfirm

PKGS=(
#'autojump'
#'brave-bin' # Brave Browser
#'dxvk-bin' # DXVK DirectX to Vulcan
#'github-desktop-bin' # Github Desktop sync
#'lightly-git'
#'mangohud' # Gaming FPS Counter
#'mangohud-common'
#'nerd-fonts-fira-code'
#'nordic-darker-standard-buttons-theme'
#'nordic-darker-theme'
#'nordic-kde-git'
#'nordic-theme'
#'noto-fonts-emoji'
#'papirus-icon-theme'
#'ocs-url' # install packages from websites
#'sddm-nordic-theme-git'
#'snap-pac'
'snap-pac-grub'
'snapper-gui-git'
#'ttf-hack'
)

for PKG in "${PKGS[@]}"; do
    sudo yay -S --noconfirm $PKG
done

export PATH=$PATH:~/.local/bin

rm -rf ~/dev/yay

############################################################################################################
############################   ENABLE SERVICES   ###########################################################
############################################################################################################
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager
sudo systemctl enable cups.service
sudo systemctl enable reflector.timer
