#!/bin/bash

file=$(zenity --file-selection --filename $HOME/Pictures/)

if [[ $file == "" ]]; then
    exit 0
fi

~/.config/eww/scripts/material.py --image "$file"
