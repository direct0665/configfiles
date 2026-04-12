#!/bin/bash

# Pfad-Erkennung
REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
echo "--- starte setup in $REPO_ROOT ---"
cd "$REPO_ROOT" || exit

# 1. Sicherheitscheck
if [[ "$(id -u)" -eq 0 ]]; then
    echo "FEHLER: Bitte als normaler Benutzer ausführen!" >&2
    exit 1
fi

# 2. yay installieren (falls nötig)
if ! command -v yay &> /dev/null; then
    echo ">>> installiere yay"
    git clone https://aur.archlinux.org/yay.git "$HOME/yay-build"
    cd "$HOME/yay-build" && makepkg -si --noconfirm
    cd "$REPO_ROOT" && rm -rf "$HOME/yay-build"
fi

# 3. ZSH als Standard-Shell setzen
if [[ "$SHELL" != */zsh ]]; then
    echo ">>> Setze ZSH als Standard-Shell..."
    sudo pacman -S --needed --noconfirm zsh
    chsh -s $(which zsh)
fi

# 4. GIT CONFIG FIX
git config core.filemode true

# --- DARKMODE KONFIGURATION ---
echo ">>> konfiguriere darkmode..."
if command -v gsettings >/dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-3.0/settings.ini"
echo -e "[Settings]\ngtk-application-prefer-dark-theme=1" > "$HOME/.config/gtk-4.0/settings.ini"

# Zsh-Exports (verhindert Dopplungen)
if [ -f "$HOME/.zshrc" ]; then
    grep -qq "QT_QPA_PLATFORMTHEME" "$HOME/.zshrc" || echo 'export QT_QPA_PLATFORMTHEME=qt5ct' >> "$HOME/.zshrc"
    grep -qq "QT_SELECT_GUI_STYLE" "$HOME/.zshrc" || echo 'export QT_SELECT_GUI_STYLE=adwaita-dark' >> "$HOME/.zshrc"
fi

# Dolphin Darkmode Fix
mkdir -p "$HOME/.config"
echo -e "[ColorScheme]\nColorScheme=BreezeDark\n\n[General]\nColorScheme=BreezeDark" > "$HOME/.config/kdeglobals"

# 5. SKRIPTE REPARIEREN & STOW
echo ">>> Verlinke Configs und mache Skripte ausführbar..."
chmod +x "$REPO_ROOT/setup.sh"
find "$REPO_ROOT/scripts" -name "*.sh" -exec chmod +x {} + 2>/dev/null

for dir in */; do
    module=${dir%/}
    if [ "$module" != ".git" ] && [ -d "$module" ]; then
        stow --adopt "$module" 2>/dev/null || echo "Info: $module übersprungen."
    fi
done
git restore . # Macht Änderungen durch --adopt rückgängig

# Link für Magic Menu Readme
mkdir -p "$HOME/.config/scripts"
ln -sf "$REPO_ROOT/README.md" "$HOME/.config/scripts/current_readme.md"

# 6. HYPRLAND ENV FORCE
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
    echo ">>> Starte Paket-Installation..."
    local PKGLIST="$REPO_ROOT/pkglist"
    if [ -f "$PKGLIST" ]; then
        grep -v '^#' "$PKGLIST" | sed 's/#.*//' | tr -d '\r' | xargs -r yay -S --needed --noconfirm
    fi
}

echo "Sollen die Programme aus der pkglist installiert werden? (y/n)"
read -n 1 -r
echo ""
[[ $REPLY =~ ^[Yy]$ ]] && install_packages

# 7. MIME-TYPES
echo ">>> Setze Standardprogramme..."
if command -v xdg-mime >/dev/null; then
    xdg-mime default firefox.desktop text/html
    xdg-mime default firefox.desktop x-scheme-handler/http
    xdg-mime default firefox.desktop x-scheme-handler/https
    xdg-mime default mpv.desktop video/mp4 video/x-matroska audio/mpeg
    xdg-mime default imv.desktop image/png image/jpeg
    xdg-mime default org.kde.dolphin.desktop inode/directory

    ZED_APP="dev.zed.Zed.desktop"
    xdg-mime default "$ZED_APP" text/plain text/markdown text/x-rust application/json text/x-yaml
fi

echo "--- setup done ---"
echo "falls auf zsh zum ersten mal umgestellt wurde wird die änderung erst beim nächsten login aktiv"
