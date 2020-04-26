#!/bin/bash
#
# Based on script by z3bra -- 2014-01-21

W3MIMGDISPLAY="/usr/libexec/w3m/w3mimgdisplay"
FONTH=15 # Size of one terminal row
FONTW=7 # Size of one terminal column

X=$1
Y=$2
COLUMNS=$3
LINES=$4
FILENAME=$5

read width height <<< `echo "5;$FILENAME" | $W3MIMGDISPLAY`
if [ -z "$width" -o -z "$height" ]; then
    echo 'Error: Failed to obtain image size.'
    exit 1
fi

x=$((FONTW * X))
y=$((FONTH * Y))

max_width=$((FONTW * COLUMNS))
max_height=$((FONTH * LINES))

if [ "$width" -gt "$max_width" ]; then
    height=$((height * max_width / width))
    width=$max_width
fi
if [ "$height" -gt "$max_height" ]; then
    width=$((width * max_height / height))
    height=$max_height
fi

w3m_command="0;1;$x;$y;$width;$height;;;;;$FILENAME\n4;\n3;"

echo -e "$w3m_command" | $W3MIMGDISPLAY
