#!/bin/bash
# installiert/aktualisiert die pakete aus der Brewfile.
# "brew bundle" prüft selbst was schon installiert ist und installiert nur
# was fehlt -- kein custom-check nötig, kein unnötiges reinstallieren.

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

if ! command -v brew &> /dev/null; then
    echo "FEHLER: homebrew ist nicht installiert. siehe https://brew.sh" >&2
    exit 1
fi

echo "--- installiere fehlende pakete aus $REPO_ROOT/Brewfile ---"
brew bundle install --file="$REPO_ROOT/Brewfile"
