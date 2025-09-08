#!/bin/bash

# Get the SSID of the active Wi-Fi connection
ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)

# If not connected, show disconnected icon
if [ -z "$ssid" ]; then
    echo "睊   Disconnected"
else
    echo "   $ssid"
fi
