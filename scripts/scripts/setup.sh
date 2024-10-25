#!/bin/env bash

sudo pacman -Suy -y
sudo pacman -S bluez bluez-utils

echo "Creating .zshenv file ..."
touch ~/.zshenv
echo "ZDOTDIR=~/.config/zsh" > ~/.zshenv
echo "Creating .zshenv file DONE"
