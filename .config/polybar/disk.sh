#!/usr/bin/env bash

percent=$( df -H / | grep -vE '^Filesystem' | awk '{ print $5 }' )
spaceRemain=$( df -H / | grep -vE '^Filesystem' | awk '{ print $4 }' )

echo "$percent • $spaceRemain"
