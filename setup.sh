#!/bin/bash

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "--- starte setup in $REPO_ROOT ---"
cd "$REPO_ROOT" || exit

# 1. Skripte ausführbar machen
echo "mache skripte ausführbar..."
chmod +x "$REPO_ROOT/scripts/.config/scripts/"*.sh 2>/dev/null

# 2. Stow ausführen
echo "verlinke configs via stow..."
for dir in */; do
    module=${dir%/}
    if [ "$module" != ".git" ]; then
        stow "$module"
    fi
done

# 3. Darkmode erzwingen (ohne Installation)
# Wir schreiben das in eine lokale Datei, die du in deiner hyprland.conf sourcen kannst
echo "erzwinge darkmode umgebungsvariablen..."
mkdir -p ~/.config/hypr/
cat <<EOF > ~/.config/hypr/env_dark.conf
env = GTK_THEME,Adwaita:dark
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_STYLE_OVERRIDE,adwaita-dark
env = ADW_DISABLE_PORTAL,1
EOF

echo "--- done. bitte 'source = ~/.config/hypr/env_dark.conf' in deine hyprland.conf eintragen ---"
