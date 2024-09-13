#!/bin/bash


file=$@
output="${file%.txt}.mp3"
time cat "$file" | ~/dev/piper/piper --model ~/dev/piper/en_US-libritts_r-medium.onnx --output_file "$output"
