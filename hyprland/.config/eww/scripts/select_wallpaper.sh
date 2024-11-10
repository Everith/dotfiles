#!/bin/bash

file=$(zenity --file-selection --filename /server/dev)

if [[ $file == "" ]]; then
    exit 0
fi

~/.config/eww/scripts/material.py --image "$file"
