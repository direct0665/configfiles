#!/bin/bash
# fzf-gestützter launcher mit mehreren modi (apps/dateien), umschaltbar
# per ctrl-a (apps) / ctrl-f (dateien) während fzf offen ist. ersetzt
# spotlight auf macos, ergänzt wofi unter hyprland um einen zweiten weg.
# läuft in einem eigenen kleinen, zentrierten fenster (macos: skhd ->
# alt+space; hyprland: eigener alt+space-keybind + floating windowrule).
set -eu -o pipefail

SELF="${BASH_SOURCE[0]}"
# MUSS mit --instance-group in skhdrc/hyprland.lua/kitty.conf übereinstimmen
INSTANCE_GROUP="launcher"

# HIER festlegen was durchsucht wird (macos, apps-modus): jeder ordner wird
# nach .app-bundles UND nach direkt darin liegenden ausführbaren dateien
# durchsucht (z.b. ein künftiger ~/scripts-ordner mit eigenen mac-skripten).
mac_app_dirs=(
    "/Applications"
    "/System/Applications"
    "$HOME/Applications"
    # "$HOME/scripts"   # <- eigener skript-ordner, einfach einkommentieren
)
# HIER festlegen was durchsucht wird (macos, dateien-modus). braucht `fd`.
mac_file_dirs=("$HOME")
mac_file_excludes=(.git node_modules Library .Trash .cache)

# HIER festlegen was durchsucht wird (linux/hyprland, apps-modus):
linux_app_dirs=(
    "/usr/share/applications"
    "$HOME/.local/share/applications"
    # "$HOME/.config/scripts"   # <- eigene skripte, einfach einkommentieren
)
# HIER festlegen was durchsucht wird (linux/hyprland, dateien-modus). braucht `fd`.
linux_file_dirs=("$HOME")
linux_file_excludes=(.git node_modules .cache)

__list_mac_windows() {
    if ! command -v yabai &> /dev/null; then
        printf 'yabai ist nicht installiert -- fenster-modus nicht verfügbar\ttrue\n'
        return
    fi
    yabai -m query --windows 2>/dev/null |
        jq -r '.[] | select(.title != "") | "\(.app) — \(.title)\tyabai -m window --focus \(.id)"'
}

__list_linux_windows() {
    if ! command -v hyprctl &> /dev/null; then
        printf 'hyprctl nicht gefunden -- fenster-modus nicht verfügbar\ttrue\n'
        return
    fi
    hyprctl clients -j 2>/dev/null |
        jq -r '.[] | select(.title != "") | "\(.class) — \(.title)\thyprctl dispatch focuswindow address:\(.address)"'
}

__list_mac_apps() {
    # WICHTIG: namen über bash-parameter-expansion (${x##*/} usw.) statt
    # externem `basename`-aufruf pro datei -- bei ~100+ apps kostet das
    # sonst ~200ms allein durchs subprozess-spawnen (gemessen, siehe infos.dj)
    for dir in "${mac_app_dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        while IFS= read -r -d '' app; do
            name="${app##*/}"
            printf '%s\topen -a %q\n' "${name%.app}" "$app"
        done < <(find "$dir" -maxdepth 2 -iname "*.app" -print0 2>/dev/null)
        while IFS= read -r -d '' exe; do
            printf '%s\t%q\n' "${exe##*/}" "$exe"
        done < <(find "$dir" -maxdepth 1 -type f -perm -u+x ! -iname "*.app" -print0 2>/dev/null)
    done | sort -u -t $'\t' -k1,1
}

__list_mac_files() {
    if ! command -v fd &> /dev/null; then
        printf 'fd ist nicht installiert -- dateisuche nicht verfügbar\ttrue\n'
        return
    fi
    local exclude_args=()
    for e in "${mac_file_excludes[@]}"; do exclude_args+=(-E "$e"); done
    for dir in "${mac_file_dirs[@]}"; do
        fd --type f "${exclude_args[@]}" . "$dir" 2>/dev/null
    done | while IFS= read -r f; do
        printf '%s\topen %q\n' "${f/#$HOME/~}" "$f"
    done
}

__list_linux_apps() {
    # WICHTIG: .desktop-dateien mit bashs eigenem `read`/case statt sed/grep
    # pro datei parsen -- bei vielen apps sonst 2-3 subprozess-spawns pro
    # datei, kostet spürbar zeit (siehe gleiches problem im mac-teil, infos.dj)
    for dir in "${linux_app_dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        for f in "$dir"/*.desktop; do
            [[ -f "$f" ]] || continue
            local name="" exec_line="" no_display=""
            while IFS='=' read -r key val; do
                case "$key" in
                    Name) [[ -z "$name" ]] && name="$val" ;;
                    Exec) [[ -z "$exec_line" ]] && exec_line="${val//%[a-zA-Z]/}" ;;
                    NoDisplay) no_display="$val" ;;
                esac
            done < "$f"
            [[ "$no_display" == "true" ]] && continue
            [[ -n "$name" && -n "$exec_line" ]] && printf '%s\t%s\n' "$name" "$exec_line"
        done
    done | sort -u -t $'\t' -k1,1
}

__list_linux_files() {
    if ! command -v fd &> /dev/null; then
        printf 'fd ist nicht installiert -- dateisuche nicht verfügbar\ttrue\n'
        return
    fi
    local exclude_args=()
    for e in "${linux_file_excludes[@]}"; do exclude_args+=(-E "$e"); done
    for dir in "${linux_file_dirs[@]}"; do
        fd --type f "${exclude_args[@]}" . "$dir" 2>/dev/null
    done | while IFS= read -r f; do
        printf '%s\txdg-open %q\n' "${f/#$HOME/~}" "$f"
    done
}

# interner modus-aufruf -- wird von fzf selbst per "reload" benutzt (siehe
# --bind unten), kein direkter aufruf nötig
if [[ "${1:-}" == "__list" ]]; then
    mode="$2"
    if [[ "$(uname)" == "Darwin" ]]; then
        case "$mode" in
            apps) __list_mac_apps ;;
            files) __list_mac_files ;;
            windows) __list_mac_windows ;;
        esac
    else
        case "$mode" in
            apps) __list_linux_apps ;;
            files) __list_linux_files ;;
            windows) __list_linux_windows ;;
        esac
    fi
    exit 0
fi

# versteckt das eigene quick-access-terminal-fenster wieder, statt den
# prozess zu beenden. WICHTIG: ein einmal beendeter prozess muss beim
# nächsten alt+space komplett neu erzeugt werden (~450ms, fast wie ein
# kaltstart), während das reine ein-/ausblenden einer noch laufenden
# session ~40-50ms braucht (gemessen, siehe infos.dj) -- deswegen läuft
# dieses skript in einer schleife und beendet sich nie von selbst.
__hide_self() {
    if [[ "$(uname)" == "Darwin" ]]; then
        /Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal --instance-group "$INSTANCE_GROUP" >/dev/null 2>&1 &
    else
        kitten quick-access-terminal --instance-group "$INSTANCE_GROUP" >/dev/null 2>&1 &
    fi
    disown 2>/dev/null || true
}

while true; do
    selected=$(
        "$SELF" __list apps | fzf \
            --prompt="apps> " \
            --height=100% --reverse --info=hidden \
            --delimiter=$'\t' --with-nth=1 \
            --header="alt-1: apps   alt-2: dateien   alt-3: fenster" \
            --bind "alt-1:reload($SELF __list apps)+change-prompt(apps> )" \
            --bind "alt-2:reload($SELF __list files)+change-prompt(dateien> )" \
            --bind "alt-3:reload($SELF __list windows)+change-prompt(fenster> )"
    ) || true

    if [[ -n "${selected:-}" ]]; then
        cmd=$(printf '%s' "$selected" | cut -f2)
        if [[ "$(uname)" == "Darwin" ]]; then
            eval "$cmd" || true
        else
            setsid -f $cmd >/dev/null 2>&1 &
            disown
        fi
    fi

    __hide_self
done
