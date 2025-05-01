# ~/.zshrc - Minimale Zsh-Konfiguration (Garuda-ähnlicher Prompt)

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
# Zeigt Branch-Namen, geänderte Dateien (*), Staged-Dateien (+)
zstyle ':vcs_info:git:*' formats '(%b%u%c)' # Branch, untracked (?), changed (*)
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)' # Action (rebase etc.), Branch, untracked, changed
zstyle ':vcs_info:*' enable git # Nur Git aktivieren

# Prompt-Funktion (wird vor jeder Prompt-Anzeige ausgeführt)
precmd() {
  # Füllt vcs_info mit Infos aus dem aktuellen Verzeichnis
  vcs_info
}

# Farben definieren (optional, anpassbar)
local user_color="%F{cyan}"
local host_color="%F{blue}"
local dir_color="%F{green}"
local git_color="%F{magenta}"
local reset_color="%f" # Farbe zurücksetzen

# Zweizeiliger Prompt
# Zeile 1: [user@host]
# Zeile 2: Verzeichnis > Git-Status $ (oder # für root)
PROMPT="${user_color}%n${reset_color}@${host_color}%m${reset_color} " # Zeile 1: user@host
PROMPT+="%# " # Fügt '#' für root hinzu, sonst '%' - wird am Ende von Zeile 2 platziert

RPROMPT="" # Rechter Prompt (leer)

# Zweite Zeile des Prompts (wird über PS2 oder eine Variable gesteuert - hier einfacher über PROMPT)
# Wir bauen die zweite Zeile und fügen sie dem PROMPT hinzu.
# \n für neue Zeile, %~ für Verzeichnis (~ für Home), vcs_info_msg_0_ für Git-Infos
PROMPT=$'%{\n%}${dir_color}%~${reset_color} ${git_color}${vcs_info_msg_0_}${reset_color}\n$PROMPT'

# --- Aliases ---
alias ls='ls --color=auto'
alias ll='ls -lAh --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias c='clear'
alias update='sudo pacman -Syu' # Beispiel für Arch Linux

# --- Optional: Syntax Highlighting & Autosuggestions ---
# Diese verbessern das Erlebnis erheblich, benötigen aber Installation.
# Methode 1: Mit einem Plugin-Manager (z.B. zinit, zplug, antigen)
#   -> Folge der Anleitung deines Plugin-Managers
# Methode 2: Manuell klonen und sourcen (Beispiel)
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#   source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#   source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#   *Hinweis: Der Pfad mit oh-my-zsh ist nur ein Beispiel, passe ihn an oder lege sie in ~/.zsh/ ab.*

# Wenn Syntax Highlighting installiert ist:
# ZSH_HIGHLIGHT_STYLES[comment]='fg=blue' # Beispielanpassung

# --- Ende der .zshrc ---
