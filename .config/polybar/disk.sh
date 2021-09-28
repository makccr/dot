#!/usr/bin/env bash

percent=$( # Pulling percent of drive used
    df -H / | grep -vE '^Filesystem' | awk '{ print $5 }' 
    )

spaceRemain=$( # Pulling storage in gigabytes left
    df -H / | grep -vE '^Filesystem' | awk '{ print $4 }' 
    )

# Printing both percentage used, and space remaining together
echo "$percent • $spaceRemain"
