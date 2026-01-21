#!/bin/bash
# Wrapper for Resolve HiDPI on ThinkPad P1
#
# Step 1: Scale screen down by 2x
xrandr --output DP-2 --scale 0.5x0.5

# Step 2: Launch Resolve
/opt/resolve/bin/resolve

# Step 3: Restore native scale
xrandr --output DP-2 --scale 1x1

