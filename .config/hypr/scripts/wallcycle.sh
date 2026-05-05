#!/bin/bash

WALLDIR="$HOME/Pictures/wallpapers/wallpapers/art/"
PIDFILE="/tmp/wall-loop.pid"

echo $$ > "$PIDFILE"

while true; do
    IMG=$(find "$WALLDIR" -type f | shuf -n 1)

    awww img "$IMG" \
        --transition-type none

    sleep 1800  # 30 minutes
done
