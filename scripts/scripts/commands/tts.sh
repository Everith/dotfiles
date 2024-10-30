#!/bin/bash

ffmpeg -y -f alsa -i default -acodec pcm-s16le -ac 1 -ar 44100 -t 4 -f wav ~/.cache/stt.wav >/dev/null 2>&1
vosk-transcrier -m ~/model/path -i ~/.cache/stt.wav -o ~/.cache/stt.txt >/dev/null 2>&1
cat ~/.cache/stt.txt

