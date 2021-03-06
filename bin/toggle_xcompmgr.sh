#!/bin/bash
#=#=#=
# This script toggle enabling the composite manager xcompmgr.
#
# I don't use xcompmgr because it's slightly buggy.
#=#=

if pgrep xcompmgr &> /dev/null; then
    echo "Turning xcompmgr OFF"
    pkill xcompmgr &
else
    echo "Turning xcompmgr ON"
    xcompmgr -cCfF -t-10 -l-10 -r7 -D2 -I.2 -O.2 &
fi

exit 0
