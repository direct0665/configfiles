#!/bin/bash
# macos-pendant zum stow-teil von setup.sh (das ist arch/hyprland-only).
# stowt nur die module die auf macos sinn ergeben -- linux/hyprland-only
# module (hyprland, hyprlock, waybar, wofi) werden bewusst übersprungen.

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$REPO_ROOT" || exit 1

if ! command -v stow &> /dev/null; then
    echo "FEHLER: stow ist nicht installiert. ./brew-setup.sh installiert es mit." >&2
    exit 1
fi

mac_modules=(zsh kitty git helix skhd yazi scripts)

# bewusst OHNE --adopt/git restore: das repo hier ist im alltag fast nie
# sauber/uncommitted-frei, und --adopt + "git restore ." würde dann jedes
# mal alle uncommitteten änderungen im repo verwerfen. bei echten
# konflikten einfach die gemeldete datei manuell prüfen.
echo "--- stowe module für macos: ${mac_modules[*]} ---"
for module in "${mac_modules[@]}"; do
    if [ -d "$module" ]; then
        stow "$module" 2>/dev/null || echo "Info: $module übersprungen (konflikt? siehe 'stow $module' für details)."
    fi
done
