#!/bin/sh

killall conky

        echo "jumping to target directory"
        cd "$(dirname "$0")"

    echo "starting conky"
    sleep 1
    ( set -x; setsid conky -c WO-conky-system-lua-v3.conkyrc )
    sleep 3

    echo "exiting......"
    sleep 2

exit
