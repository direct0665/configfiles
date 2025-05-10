# ~/.zshrc - Minimale Zsh-Konfiguration 

# --- History ---
HISTFILE=~/.zsh_history       # Speicherort der History-Datei
HISTSIZE=10000                # Anzahl der Zeilen im Speicher
SAVEHIST=10000                # Anzahl der Zeilen in der Datei
setopt appendhistory          # Einträge anhängen statt überschreiben
setopt sharehistory           # History zwischen allen Terminals teilen (sofort)
setopt hist_ignore_dups       # Keine Duplikate direkt nacheinander speichern
setopt hist_ignore_space      # Zeilen, die mit Leerzeichen beginnen, nicht speichern
setopt hist_verify            # History-Expansion anzeigen, bevor sie ausgeführt wird
setopt inc_append_history     # Einträge sofort anhängen

# --- Completion System ---
# Zsh's mächtiges Autovervollständigungs-System aktivieren
# Ignoriere unsichere Verzeichnisse für compinit, falls nötig (z.B. bei globalen Installationen)
# Sicherheitswarnung umgehen: compinit -i -u -d ~/.cache/zcompdump-$ZSH_VERSION
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select # Menü-Auswahl für Vervollständigungen
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Farben für Vervollständigungen verwenden

# --- Options ---
setopt autocd                 # Direkt in Verzeichnisse wechseln, ohne 'cd'
setopt correct                # Befehle automatisch korrigieren (nachfragen)
setopt extendedglob           # Erweiterte Globbing-Funktionen aktivieren
setopt notify                 # Sofort über abgeschlossene Hintergrundjobs informieren
setopt prompt_subst           # Erlaube Parameter-Expansion und Command-Substitution im Prompt

# --- Keybindings (Emacs-Stil ist Standard) ---
# bindkey -v # Uncomment für Vi-Modus

# --- Prompt ---
# Lade benötigte Module für Prompt-Anpassung und Git-Infos
autoload -Uz colors vcs_info promptinit
colors && promptinit

# Definiere das Format für Git-Informationen (vcs_info)
# Zeigt Branch-Namen (*=geändert, +=gestaged, ?=untracked)
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b%u%c)%f' # (branch*+?) in Magenta
zstyle ':vcs_info:git:*' actionformats '%F{magenta}(%b|%a%u%c)%f' # Action (rebase etc.)
zstyle ':vcs_info:*' enable git # Nur Git aktivieren

# Prompt-Funktion (wird vor jeder Prompt-Anzeige ausgeführt)
precmd() {
  # Füllt vcs_info mit Infos aus dem aktuellen Verzeichnis
  vcs_info
}

# --- Prompt Definition (PS1) ---
# Farben definieren
local user_color="%F{#FF0080}"
local host_color="%F{#AEFFD8}"
local dir_color="%F{#F6AE2D}"
local prompt_char_color="%F{#FF0080}"
local reset_color="%f"

# Definitionen
local clean_text="ZSH "

# Zeile 1: [user@host]
PS1="${user_color}%m" # {clean_text} " # ${reset_color}@${host_color}%m${reset_color} "

# Zeile 2: Verzeichnis > Git-Status $ (oder # für root)
# %{\n%} = Neue Zeile (innerhalb von %{...%} damit die Breite korrekt berechnet wird)
# %~ = Aktuelles Verzeichnis (~ für Home)
# ${vcs_info_msg_0_} = Git-Status von vcs_info (wird in precmd gefüllt)
# %# = Zeigt '#' für root, '%' für normale Benutzer
PS1+=$'%{\n%}${dir_color}%~${reset_color} ${vcs_info_msg_0_}${prompt_char_color}>> ${reset_color} '

# --- Rechter Prompt (RPROMPT) ---
# Beispiel: Zeigt die aktuelle Uhrzeit in Gelb an
RPROMPT="%F{#FF0080}%T" # %T für HH:MM:SS (24h)

# --- Aliases ---
alias ls='ls --color=auto'
alias ll='ls -lAh --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias c='clear'
alias gre='brew upgrade --greedy'
alias upd='yay -Syu' 
alias jinx='liquidctl --match kraken set sync color fixed 000080 && liquidctl --match smart set sync color fixed ff0080'
alias ]+='Hyprland'


# --- PATH Konfiguration ---
# Füge benutzerdefinierte bin-Verzeichnisse zum PATH hinzu, falls sie existieren
# und noch nicht im PATH sind.
# ~/.local/bin (Standard für pipx etc.)
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
# ~/bin (Älterer Standard)
if [[ -d "$HOME/bin" ]] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi
# (Optional) Cargo (Rust)
# if [[ -d "$HOME/.cargo/bin" ]] && [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
#   export PATH="$HOME/.cargo/bin:$PATH"
# fi
# (Optional) Go
# if [[ -d "$HOME/go/bin" ]] && [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
#   export PATH="$HOME/go/bin:$PATH"
# fi

# --- Optional: Syntax Highlighting & Autosuggestions ---
# Diese verbessern das Erlebnis erheblich, benötigen aber Installation.
# Siehe vorherige Anleitung für Installationsmethoden.
# Beispiel-Pfad (anpassen!): ZSH_PLUGINS_DIR=~/.zsh/plugins
# if [[ -f "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
#   source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# fi
# if [[ -f "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
#   source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
# fi

# --- Ende der .zshrc ---
