#!/bin/bash

ffmpeg -r 60 -i ./frame/%03d.png -vcodec libx264 -pix_fmt yuv420p -r 60 glimpse.mp4
