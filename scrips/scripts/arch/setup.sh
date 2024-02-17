#!/bin/env bash

echo "Linking .config files ..."
ln -sr ../nvim ~/.config/
ln -sr ../zsh ~/.config/
ln -sr ../gti ~/.config/
ln -sr ../scrips ~/.config/
echo "Linking .config DONE "

echo "Creating .zshenv file ..."
touch ~/.zshenv
echo "ZDOTDIR=~/.config/zsh" > ~/.zshenv
echo "Creating .zshenv file DONE"
