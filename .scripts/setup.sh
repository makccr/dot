#!/usr/bin/env bash

for f in .config .scripts .gitconfig .zshenv .tmux.conf .Xresources .xbindkeysrc; do
    ln -sf "$HOME/Documents/dot/$f" .
done
