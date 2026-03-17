#!/bin/bash

find /srv/data/cctv/* -type f -mtime +7 -exec rm {} \;
