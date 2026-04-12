#!/bin/bash

# Pfad-Erkennung (Egal ob der Ordner configfiles oder dotfiles heißt)
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "--- 🚀 Starte Setup in $REPO_ROOT ---"
cd "$REPO_ROOT" || exit

# 1. GIT CONFIG FIX (Sicherstellen, dass Rechte getrackt werden)
git config core.filemode true

if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-3.0/settings.ini"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-4.0/settings.ini"

# 2. qt settings (für dolphin/gaming apps)
# wir erzwingen das dunkle thema über die umgebungsvariable
if [ -f "$HOME/.zshenv" ] || [ -f "$HOME/.zshrc" ]; then
    # wir schreiben es in die .zshenv, damit es überall (auch hyprland) greift
    echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> "$HOME/.zshenv"
    echo 'export QT_SELECT_GUI_STYLE=adwaita-dark' >> "$HOME/.zshenv"
    echo "  qt variablen gesetzt"
fi

# 3. kdeglobals (der direkte weg für dolphin)
mkdir -p "$HOME/.config"
echo -e "[ColorScheme]\nColorScheme=BreezeDark\n\n[General]\nColorScheme=BreezeDark" > "$HOME/.config/kdeglobals"

echo "  darkmode vollständig konfiguriert"

# 2. SKRIPTE REPARIEREN
echo "Mache Skripte ausführbar..."
chmod +x "$REPO_ROOT/setup.sh"
chmod +x "$REPO_ROOT/scripts/.config/scripts/"*.sh 2>/dev/null || true

# 3. STOW (Verlinken)
echo "Verlinke Konfigurationen..."
for dir in */; do
    module=${dir%/}
    if [ "$module" != ".git" ]; then
        stow "$module" 2>/dev/null || echo "Info: $module konnte nicht gestowed werden (evtl. bereits vorhanden)."
    fi
done

echo "Erstelle Link zur README für das Magic Menu..."
ln -sf "$REPO_ROOT/README.md" "$HOME/.config/scripts/current_readme.md"

# 4. FIREFOX & GTK DARKMODE FORCE (Der Kern-Fix)
echo "Erzwinge Darkmode Konfiguration..."
mkdir -p ~/.config/hypr/

cat <<EOF > ~/.config/hypr/env_dark.conf
# --- Generiert vom Setup-Script ---
# GTK & QT Themes auf Dark setzen
env = GTK_THEME,Adwaita:dark
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_STYLE_OVERRIDE,adwaita-dark

# Firefox & GTK4 Header Fix (Wayland Support & Dark Preference)
env = MOZ_ENABLE_WAYLAND,1
env = GDK_BACKEND,wayland
env = GTK_USE_PORTAL,1
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
EOF

echo "--- done.  'source = ~/.config/hypr/env_dark.conf' in deine hyprland.conf eintragen ---"
