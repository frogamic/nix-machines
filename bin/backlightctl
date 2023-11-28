#! /usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

if [[ "$#" != "2" ]] || ! [[ "$1" =~ (inc|dec) ]]; then
	echo "Usage: $(basename "$0") [inc|dec] [percentage]"
	exit 1
fi

if [[ "$1" == "inc" ]]; then
	CHANGE="+${2}%"
else
	CHANGE="${2}%-"
fi

PCT=$(brightnessctl -m -c "backlight" set "$CHANGE" | cut -d "," -f 4)
PCT="${PCT%\%}"
KBD=0
if [ $PCT -eq 0 ]; then
	KBD=0
elif [ $PCT -lt 40 ]; then
	KBD=1
elif [ $PCT -lt 60 ]; then
	KBD=2
fi
brightnessctl -d "tpacpi::kbd_backlight" set "$KBD" > /dev/null
echo "$PCT"
