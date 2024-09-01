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

sudo rm -r ~/yay
sudo cp -r /root/.ssh /home/erik/.ssh

git clone --recursive git@github.com:Everith/dotfiles.git
cd dotfiles
git switch dev
stow git hyper kitty scripts nvim zsh
cd

gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
gsettings set org.gnome.desktop.interface icon-theme Papirus
gsettings set org.gnome.desktop.interface font-name "JetBrains Mono Regular 11"

echo "###########################"
echo "### Stage 2 completed #####"
echo "###########################"

exit