#!/bin/bash

# Pfad-Erkennung (Egal ob der Ordner configfiles oder dotfiles heißt)
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "--- 🚀 Starte Setup in $REPO_ROOT ---"
cd "$REPO_ROOT" || exit

# 1. GIT CONFIG FIX
git config core.filemode true

# --- DARKMODE KONFIGURATION ---
if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-3.0/settings.ini"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-4.0/settings.ini"

# QT & Environment (Zsh)
if [ -f "$HOME/.zshrc" ]; then
    # Nur anhängen, wenn noch nicht drin (verhindert Dopplungen)
    grep -qq "QT_QPA_PLATFORMTHEME" "$HOME/.zshrc" || echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> "$HOME/.zshrc"
    grep -qq "QT_SELECT_GUI_STYLE" "$HOME/.zshrc" || echo 'export QT_SELECT_GUI_STYLE=adwaita-dark' >> "$HOME/.zshrc"
    echo "  qt variablen in .zshrc geprüft"
fi

# Dolphin Fix
mkdir -p "$HOME/.config"
echo -e "[ColorScheme]\nColorScheme=BreezeDark\n\n[General]\nColorScheme=BreezeDark" > "$HOME/.config/kdeglobals"
echo "  darkmode vollständig konfiguriert"

# 2. SKRIPTE REPARIEREN
echo "Mache Skripte ausführbar..."
chmod +x "$REPO_ROOT/setup.sh"
# Findet alle Skripte im Unterordner
find "$REPO_ROOT/scripts" -name "*.sh" -exec chmod +x {} + 2>/dev/null

# 3. STOW (Verlinken)
echo "Verlinke Konfigurationen..."
for dir in */; do
    module=${dir%/}
    if [ "$module" != ".git" ] && [ -d "$module" ]; then
        stow "$module" 2>/dev/null || echo "Info: $module übersprungen (evtl. bereits vorhanden)."
    fi
done

# Spezieller Link für dein Magic Menu
mkdir -p "$HOME/.config/scripts"
ln -sf "$REPO_ROOT/README.md" "$HOME/.config/scripts/current_readme.md"

# 4. HYPRLAND ENV FORCE (Der Kern-Fix für Firefox & GTK)
echo "Erzwinge Darkmode Konfiguration..."
mkdir -p ~/.config/hypr/
cat <<EOF > ~/.config/hypr/env_dark.conf
# --- Generiert vom Setup-Script ---
env = GTK_THEME,Adwaita:dark
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_STYLE_OVERRIDE,adwaita-dark
env = MOZ_ENABLE_WAYLAND,1
env = GDK_BACKEND,wayland
env = GTK_USE_PORTAL,1
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
EOF

# --- FUNKTION FÜR DIE PAKET-INSTALLATION ---
install_packages() {
    echo "> starte paket-installation aus pkglist"
    PKGLIST="$REPO_ROOT/pkglist" # Nutzt direkt den oben erkannten Root

    if [ -f "$PKGLIST" ]; then
        grep -v '^#' "$PKGLIST" | sed 's/#.*//' | tr -d '\r' | xargs -r yay -S --needed --noconfirm
        echo "  installation abgeschlossen"
    else
        echo "  fehler: pkglist nicht gefunden in $REPO_ROOT"
    fi
}

# --- ABFRAGE PAKETE ---
echo "sollen die programme aus der pkglist installiert werden? (y/n)"
read -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_packages
fi

# --- MIME-TYPES (Standardprogramme) ---
echo "> setze standardprogramme für dateitypen"
if command -v xdg-mime >/dev/null; then
    xdg-mime default firefox.desktop text/html
    xdg-mime default firefox.desktop x-scheme-handler/http
    xdg-mime default firefox.desktop x-scheme-handler/https
    xdg-mime default mpv.desktop video/mp4
    xdg-mime default mpv.desktop video/x-matroska
    xdg-mime default imv.desktop image/png
    xdg-mime default imv.desktop image/jpeg
    xdg-mime default org.kde.dolphin.desktop inode/directory

    ZED_APP="dev.zed.Zed.desktop"

    # text & markdown
    xdg-mime default "$ZED_APP" text/plain
    xdg-mime default "$ZED_APP" text/markdown

    # rust & programming
    xdg-mime default "$ZED_APP" text/x-rust
    xdg-mime default "$ZED_APP" text/x-c++src
    xdg-mime default "$ZED_APP" text/x-csrc
    xdg-mime default "$ZED_APP" text/x-python
    xdg-mime default "$ZED_APP" application/x-shellscript

    # json & config files (oft wichtig für deine dotfiles)
    xdg-mime default "$ZED_APP" application/json
    xdg-mime default "$ZED_APP" text/x-yaml

    echo "  mime-types erfolgreich hinterlegt"
fi

echo "--- setup done."
