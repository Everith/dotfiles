#!/bin/bash

input=$(cat -)

#echo "$input" | piper --model ~/Downloads/en_US-amy-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw -
#echo "$input" | piper --model ~/Downloads/en_US-libritts_r-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw -
echo "$input" | piper --model ~/Downloads/hu_HU-anna-medium.onnx --output-raw | aplay -r 22050 -f S16_LE -t raw -
