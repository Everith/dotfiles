#!/bin/bash

if [ -z "$1" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.4
elif [ "$1" -gt 1 ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "0.$1"
else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$1"
fi
