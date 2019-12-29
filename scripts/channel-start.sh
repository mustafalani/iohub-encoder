#!/bin/sh
startcommand=$1
#startcommand="$(until ffmpeg -video_input sdi -audio_input embedded -channels 16 -f decklink -i 'DeckLink Duo (1)' -f libndi_newtek OTT-EN-04-NDI-01-NEW -threads 16; do echo 'looop';done)"
startc="$startcommand"
$startc
#while echo 'starting..';
#/home/ls/iohub/scripts/channel-loop.sh
#until $startcommand
#do
#echo 'rebooting..'
#done
