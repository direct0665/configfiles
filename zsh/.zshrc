# ZSH Konfiguration Paul

# --- History ---
HISTFILE=~/.zsh_history       # Speicherort der History-Datei
HISTSIZE=50000                # Maximale Anzahl der Zeilen im Arbeitsspeicher
SAVEHIST=50000                # Maximale Anzahl der Zeilen in der History-Datei
setopt appendhistory          # Neue Einträge an die Datei anhängen
setopt sharehistory           # History sofort zwischen laufenden Terminals synchronisieren
setopt hist_ignore_dups       # Direkte Duplikate nicht speichern
setopt hist_ignore_all_dups   # Ältere Duplikate bei neuen Einträgen entfernen
setopt hist_ignore_space      # Befehle mit führendem Leerzeichen ignorieren
setopt hist_verify            # History-Expansion vor Ausführung zur Kontrolle anzeigen
setopt inc_append_history     # Befehle direkt nach Ausführung zur Datei hinzufügen

# --- Completion System ---
autoload -Uz compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
compinit

# --- Options ---
setopt autocd                 # Ohne 'cd' in Verzeichnisse wechseln
setopt correct                # Tippfehlerkorrektur für Befehle
setopt extendedglob           # Erweiterte Mustererkennung (Globbing) aktivieren
setopt prompt_subst           # Variablen und Befehlssubstitution im Prompt erlauben

# --- Keybindings ---
bindkey -e                    # Emacs-Tastenkürzel verwenden
bindkey '^[[A' up-line-or-search   # Pfeil hoch: History durchsuchen basierend auf Eingabe
bindkey '^[[B' down-line-or-search # Pfeil runter: History durchsuchen basierend auf Eingabe

# --- Prompt ---
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats '%F{magenta}(%b|%a%u%c)%f'
zstyle ':vcs_info:*' enable git

precmd() {
  vcs_info
}

# Prompt Definition (PS1)
PS1='%F{#FF0080}%m%f$'\n'%F{#F6AE2D}%~%f ${vcs_info_msg_0_}%F{#FF0080}>>%f '

# Rechter Prompt
RPROMPT="%F{#FF0080}%T%f"

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
alias ]+='start-hyprland'
alias ze='zeditor'

alias l='eza --color=auto --icons=auto'
alias ll='eza -al --color=auto --icons=auto --git'
alias tree='eza --tree --color=auto --icons=auto'

alias b='bat'

eval "$(zoxide init zsh)"

# --- PATH Konfiguration ---
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if [[ -d "$HOME/bin" ]] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

# --- Zsh Plugins ---
# zsh-autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# zsh-syntax-highlighting
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -z "$DISPLAY" ]] && [[ "$TTY" == "/dev/tty1" ]]; then
  start-hyprland
fi
