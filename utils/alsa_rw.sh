#!/bin/bash

amixer -D hw:2 sset Mic 75%
amixer -c 3 cset name='PCM Playback Volume' 75%
sleep 1

folders=(
  Bearing
  Flywheel
  Healthy
  LIV
  LOV
  NRV
  Piston
  Riderbelt
)

for folder in "${folders[@]}"
do
  folder="AirCompressorDataset/${folder}"

  for ((cnt=1;cnt<=225;cnt++))
  do
    filename="preprocess_Reading${cnt}.wav"
    readfile="/home/pi/Music/alsa/r/${folder}/${filename}"
    writefile="/home/pi/Music/alsa/w/${folder}/${filename}"
    aplay ${readfile} &
    arecord --channels 1 --format S16_LE --r 44100 --duration 3 ${writefile}
    wait
    sleep 1
  done
done