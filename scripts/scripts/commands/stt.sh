#!/bin/bash

ffmpeg -y -f alsa -i default -ac 1 -ar 44100 -t 4 -f wav ~/.cache/stt.wav >/dev/null 2>&1
  vosk-transcriber -m ~/Downloads/vosk-model-en-us-0.22-lgraph/ -i ~/.cache/stt.wav -o ~/.cache/stt.txt >/dev/null 2>&1
cat ~/.cache/stt.txt

