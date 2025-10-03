#!/bin/bash

# Check if any Wi-Fi connection is active
if nmcli -t -f ACTIVE dev wifi | grep -q '^yes'; then
    # Connected → show "check" icon
    echo ""  # you can replace this with your preferred "connected" icon
else
    # Not connected → show "X" icon
    echo "󱚼"  # or whatever "disconnected" icon you want
fi
