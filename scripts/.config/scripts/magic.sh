#!/bin/bash

# 1. Die Liste für Wofi (HIER müssen alle Optionen rein!)
# Wichtig: Alle Optionen, die du unten im 'case' hast, müssen hier oben stehen.
options="power\naudio\nupdate\nclipboard\nreadme (local)\ngithub (remote)\ncockpit"

# Auswahlmenü aufrufen
op=$(echo -e "$options" | wofi -dmenu -p "magic:")

case $op in
    power)
        sh ~/.config/scripts/power-menu.sh ;;
    audio)
        pavucontrol ;;
    update)
        kitty -e yay -Syu ;;
    clipboard)
        cliphist list | wofi -dmenu | cliphist decode | wl-copy ;;
    "readme (local)")
        # Nutzt jetzt den Symlink aus dem setup.sh
        kitty --title "README" -e bat --paging=always "$HOME/.config/scripts/current_readme.md" ;;
    "github (remote)")
        firefox "https://github.com/direct0665/configfiles" ;;
    cockpit)
        firefox "https://localhost:9090" ;;
esac
