#!/usr/bin/env bash
# screenshot wie auf dem mac: "full" = ganzer bildschirm, "area" = auswahl.
# landet als datei in ~/Pictures/Screenshots UND in der zwischenablage.
# tasten: super+ctrl+3 / super+ctrl+4 (super+shift+zahl verschiebt fenster).
set -euo pipefail

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/Bildschirmfoto_$(date +%Y-%m-%d_%H-%M-%S).png"

case "${1:-area}" in
    full) grim "$file" ;;
    area)
        # abbruch mit esc in slurp ist kein fehler
        geom=$(slurp) || exit 0
        grim -g "$geom" "$file"
        ;;
    *) echo "usage: $0 full|area" >&2; exit 1 ;;
esac

wl-copy --type image/png < "$file"
notify-send -a screenshot -i "$file" "Bildschirmfoto" "${file/#$HOME/\~}"
