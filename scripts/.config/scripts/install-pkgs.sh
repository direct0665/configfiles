#!/bin/bash

# Pfad zur pkglist (da wir stow nutzen, liegt sie im Home)
PKGLIST="$HOME/pkglist"

echo "--- Starte Paket-Installation ---"

if [ -f "$PKGLIST" ]; then
    # Installiere alles aus der Liste, was noch nicht da ist
    # Wir nutzen yay, da es sowohl Repo- als auch AUR-Pakete kann
    echo "Lese Pakete aus $PKGLIST..."

    # Der Befehl filtert Kommentare und Leerzeilen aus der pkglist
    grep -v '^#' "$PKGLIST" | sed 's/#.*//' | tr -d '\r' | xargs -r yay -S --needed --noconfirm

    echo "--- Installation abgeschlossen! ---"
else
    echo "Fehler: pkglist nicht gefunden in $HOME"
fi

# Fenster offen halten, damit man das Ergebnis sieht
echo "Drücke eine Taste zum Schließen..."
read -n 1
