#!/bin/bash

cd ~/.apps/
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
./install.sh

