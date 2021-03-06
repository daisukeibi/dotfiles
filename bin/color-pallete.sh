#!/bin/bash
# written by Shotaro Fujimoto (https://github.com/ssh0)
#=#=#=
# color-pallete.sh - Show zenity color pallete and pick a color.
#
# But it doesn't work properly in Ubuntu 14.04 because of zenity's bug.  
# >[https://bugs.launchpad.net/ubuntu/+source/zenity/+bug/1355423](https://bugs.launchpad.net/ubuntu/+source/zenity/+bug/1355423)
#=#=

if [ "$1" = '-h' ]; then
  usage_all "$0"
  exit 0
fi

color="$(zenity --color-selection --show-palette 2>/dev/null)"

case $? in
  0)
    echo "You selected $color." ;;
  1)
    echo "No color selected." ;;
  -1)
    echo "An unexpected error has occurred." ;;
esac

