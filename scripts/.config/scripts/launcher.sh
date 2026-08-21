#!/bin/bash
# fzf-gestützter app-launcher. ersetzt spotlight auf macos, ergänzt wofi
# unter hyprland um einen zweiten, schnelleren weg. läuft in einem eigenen
# kleinen terminal-fenster (macos: skhd -> alt+space -> kitty os-window;
# hyprland: kitty --title launcher -e dieses skript, eigener keybind).
set -eu -o pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    # HIER festlegen was durchsucht wird: jeder ordner wird nach .app-bundles
    # UND nach direkt darin liegenden ausführbaren dateien durchsucht (z.b.
    # ein künftiger ~/scripts-ordner mit eigenen mac-skripten).
    search_dirs=(
        "/Applications"
        "/System/Applications"
        "$HOME/Applications"
        # "$HOME/scripts"   # <- eigener skript-ordner, einfach einkommentieren
    )

    list=$(
        for dir in "${search_dirs[@]}"; do
            [[ -d "$dir" ]] || continue
            while IFS= read -r -d '' app; do
                printf '%s\topen -a %q\n' "$(basename "$app" .app)" "$app"
            done < <(find "$dir" -maxdepth 2 -iname "*.app" -print0 2>/dev/null)
            while IFS= read -r -d '' exe; do
                printf '%s\t%q\n' "$(basename "$exe")" "$exe"
            done < <(find "$dir" -maxdepth 1 -type f -perm -u+x ! -iname "*.app" -print0 2>/dev/null)
        done | sort -u -t $'\t' -k1,1
    )
    selected=$(printf '%s\n' "$list" | fzf --prompt="app > " --height=100% --reverse --info=hidden --delimiter='\t' --with-nth=1)
    [[ -n "${selected:-}" ]] || exit 0
    eval "$(printf '%s' "$selected" | cut -f2)"
else
    # HIER festlegen was durchsucht wird: .desktop-dateien (name + exec),
    # wie wofi's drun-modus. eigene skript-ordner unten einfach ergänzen.
    search_dirs=(
        "/usr/share/applications"
        "$HOME/.local/share/applications"
        # "$HOME/.config/scripts"   # <- eigene skripte, einfach einkommentieren
    )
    list=$(
        for dir in "${search_dirs[@]}"; do
            [[ -d "$dir" ]] || continue
            for f in "$dir"/*.desktop; do
                [[ -f "$f" ]] || continue
                grep -q "^NoDisplay=true" "$f" && continue
                name=$(sed -n 's/^Name=//p' "$f" | head -1)
                exec_line=$(sed -n 's/^Exec=//p' "$f" | head -1 | sed 's/%[a-zA-Z]//g')
                [[ -n "$name" && -n "$exec_line" ]] && printf '%s\t%s\n' "$name" "$exec_line"
            done
        done | sort -u -t $'\t' -k1,1
    )
    selected=$(printf '%s\n' "$list" | fzf --prompt="app > " --height=100% --reverse --info=hidden --delimiter='\t' --with-nth=1)
    [[ -n "${selected:-}" ]] || exit 0
    cmd=$(printf '%s' "$selected" | cut -f2)
    setsid -f $cmd >/dev/null 2>&1 &
    disown
fi
