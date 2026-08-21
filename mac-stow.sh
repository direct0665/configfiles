#!/bin/bash
# macos-pendant zum stow-teil von setup.sh (das ist arch/hyprland-only).

# os check bzw abbruch wenn nicht darwin
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "FEHLER: Dieses Skript ist nur für macOS gedacht!" >&2
    exit 1
fi

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$REPO_ROOT" || exit 1

if ! command -v stow &> /dev/null; then
    echo "FEHLER: stow ist nicht installiert. ./brew-setup.sh installiert es mit." >&2
    exit 1
fi

mac_modules=(zsh kitty git helix skhd yazi scripts firefox)

echo "--- stowe module für macos: ${mac_modules[*]} ---"
for module in "${mac_modules[@]}"; do
    if [ -d "$module" ]; then
        stow "$module" 2>/dev/null || echo "Info: $module übersprungen (konflikt? siehe 'stow $module' für details)."
    fi
done

# user.js für firefox verlinken
FF_DIR="$HOME/Library/Application Support/Firefox/Profiles"
if [ -d "$FF_DIR" ]; then
    PROFILE=$(find "$FF_DIR" -maxdepth 1 -type d \( -name "*.default-release" -o -name "*.default" \) | head -n 1)
    if [ -n "$PROFILE" ] && [ -f "$HOME/.config/firefox/user.js" ]; then
        ln -sf "$HOME/.config/firefox/user.js" "$PROFILE/user.js"
        echo ">>> Firefox user.js verlinkt nach: $PROFILE"
    fi
fi
