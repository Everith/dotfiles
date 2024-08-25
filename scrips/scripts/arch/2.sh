#! /bin/bash

############################################################################################################
########################   ARCH OS ERIK USER  ##############################################################
############################################################################################################

cd ~
git clone https://aur.archlinux.org/yay.git
cd ~/yay
makepkg -si --noconfirm

PKGS=(
'gradience-git'
'ttf-hack'
'adw-gtk3-git'
'eww-tray-wayland-git'
'swww'
'grimblast-git'
'python-material-color-utilities'
'hyprpicker-git'
'ttf-jetbrains-mono'
'ttf-nerd-fonts-symbols'
'papirus-icon-theme'
)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

#go get github.com/heppu/gkill  # not working jet

export PATH=$PATH:~/.local/bin
#cp -r $HOME/dotfiles/dotfiles/* $HOME/.config/

# pip install konsave
# konsave -i $HOME/dotfiles/konsave/arch.knsv
# sleep 1
# konsave -a arch

#TODO asks too many questions
#rm -r ~/yay

gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
gsettings set org.gnome.desktop.interface icon-theme Papirus
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono Regular 11"

echo "###########################"
echo "### Stage 2 completed #####"
echo "###########################"

exit