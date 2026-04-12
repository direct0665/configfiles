#!/bin/bash

# das skript ist quasi der einstiegspunkt für die custom funktionen. readme dateien, power menu, audio etc
options="power\naudio\nupdate\nsync pkgs\nclipboard\nreadme (local)\ngithub (remote)\ncockpit"

op=$(echo -e "$options" | wofi -dmenu -p "magic:")

case $op in
    power)
        sh ~/.config/scripts/power-menu.sh ;;
    audio)
        pavucontrol ;;
    update)
        kitty -e yay -Syu ;;
    "sync pkgs")
        kitty --title "Package Sync" -e sh ~/.config/scripts/install-pkgs.sh ;;
        clipboard) # funktioniert aktuell noch nicht. muss überarbeitet werden
        cliphist list | wofi -dmenu | cliphist decode | wl-copy ;;
    "readme (local)")
        kitty --hold --title "README" sh -c "glow -p ~/.config/scripts/current_readme.md" ;;
    "readme on github")
        firefox "https://github.com/direct0665/configfiles" ;;
    cockpit)
        firefox "https://localhost:9090" ;;
esac
