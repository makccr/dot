#!/usr/bin/env bash

# Installing Dmenu
cd dmenu
rm -rf config.h
sudo make clean install
cd ..
