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
    readme (local))
        # Öffnet die README in kitty. Falls du 'bat' hast, nimm 'bat', sonst 'less'
        kitty --title "README" -e less "$HOME/configfiles/README.md" ;;
    github (remote))
        # Link zu deinem Repo (hier deinen echten Link einsetzen)
        firefox "https://github.com/direct0665/configfiles" ;;
    cockpit)
        # Direkt zum lokalen Cockpit Dashboard
        firefox "https://localhost:9090" ;;
esac
