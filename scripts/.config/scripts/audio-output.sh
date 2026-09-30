#!/usr/bin/env bash
# audio-ausgang per wofi wählen (rechtsklick auf lautstärke in waybar, auch
# über den launcher-skript-tab). waybar selbst hat keine geräteliste.
set -euo pipefail

sinks=$(pactl -f json list sinks | jq -r '.[] | "\(.description)\t\(.name)"')
default=$(pactl get-default-sink)

choice=$(printf '%s\n' "$sinks" \
    | awk -F'\t' -v d="$default" '{ print ($2 == d ? "● " : "  ") $1 }' \
    | wofi --dmenu --insensitive --prompt "Ausgang") || exit 0

desc=${choice:2}
name=$(printf '%s\n' "$sinks" | awk -F'\t' -v d="$desc" '$1 == d { print $2; exit }')
[ -n "$name" ] && pactl set-default-sink "$name"
