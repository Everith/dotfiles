#!/bin/bash

find . -name "*.txt" -type f -exec ~/scripts/audio-novel.sh {} \;
