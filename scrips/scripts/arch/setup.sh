#!/bin/env bash

echo "Installing config files"
cd ~/dotfiles
stow nvim
stow zsh 
stow git
stow scrips 
stow kitty
