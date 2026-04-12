#!/bin/bash

PKGLIST="$HOME/pkglist" # pfade könnten noch etwas verfeinert werden aber erstmal macht stow hier was es soll i guess

echo "--- starte installation der pakete aus pkglist ---"

if [ -f "$PKGLIST" ]; then
    # installiert wird nur was noch nicht da ist, also kein ständiges reinstallieren (s.--needed flag).
    # yay weil manches nicht über pacman geht
    echo "lese pakete aus $PKGLIST..."

    # convoluted weil in der pkglist noch beschreibungen etc. mit # als kommentar sind
    grep -v '^#' "$PKGLIST" | sed 's/#.*//' | tr -d '\r' | xargs -r yay -S --needed --noconfirm

    echo "--- Installation abgeschlossen! ---"
else
    echo "Fehler: pkglist nicht gefunden in $HOME"
fi

# damit das fenster keinen polnischen macht
echo "irgendeine taste zum schließen drücken"
read -n 1
