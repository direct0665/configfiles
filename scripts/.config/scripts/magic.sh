#!/bin/bash

# Auswahlmenü - clean und ohne Symbole wie gewünscht
op=$(echo -e "power\naudio\nupdate\nclipboard" | wofi -dmenu -p "magic:")

case $op in
    power)
        sh ~/.config/scripts/power-menu.sh ;;
    audio)
        pavucontrol ;;
    update)
        kitty -e yay -Syu ;;
    clipboard)
        cliphist list | wofi -dmenu | cliphist decode | wl-copy ;;
esac
