#!/bin/bash

# skript für ein simples powermenu in wofi
op=$(echo -e "ausloggen\nreboot\nshutdown\nsperren" | wofi -dmenu -p "power:")

case $op in
    ausloggen)
        hyprctl dispatch exit ;;
    reboot)
        systemctl reboot ;;
    shutdown)
        systemctl poweroff ;;
    sperren)
        hyprlock ;;
esac
