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

# git- und brew-Befehle nicht in der History speichern
zshaddhistory() {
  emulate -L zsh
  [[ $1 == git\ * || $1 == brew\ * ]] && return 1
  return 0
}

# Dauer von Befehlen anzeigen, die länger als 10s laufen (praktisch bei cargo build / xcodebuild)
REPORTTIME=10
TIMEFMT='%J   %*E ges.   %U User   %S System   %P CPU'

# --- Completion System ---
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# compinit-Dump nur einmal pro Tag neu bauen statt bei jedem Shellstart (spart Zeit bei vielen Completions, z.B. cargo/rustup)
mkdir -p ~/.cache/zsh
autoload -Uz compinit
zcompdump=~/.cache/zsh/.zcompdump
if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

# --- Options ---
setopt autocd                 # Ohne 'cd' in Verzeichnisse wechseln
setopt correct                # Tippfehlerkorrektur für Befehle
setopt extendedglob           # Erweiterte Mustererkennung (Globbing) aktivieren
setopt prompt_subst           # Variablen und Befehlssubstitution im Prompt erlauben
setopt auto_pushd             # cd merkt sich besuchte Verzeichnisse (Stack)
setopt pushd_ignore_dups      # keine Duplikate im Verzeichnis-Stack
setopt pushd_silent           # kein Stack-Output bei jedem cd
setopt interactive_comments   # '#' auch interaktiv als Kommentar erlauben

# --- Keybindings ---
bindkey -e                         # Emacs-Tastenkürzel verwenden
bindkey '^[[A' up-line-or-search   # Pfeil hoch: History durchsuchen basierend auf Eingabe
bindkey '^[[B' down-line-or-search # Pfeil runter: History durchsuchen basierend auf Eingabe

# --- Prompt ---
# Nerd-Font-Icons nur aktivieren wenn das Terminal sie vermutlich rendern kann
# (kitty ist mit JetBrainsMono Nerd Font konfiguriert). Sonst Fallback auf
# reine ASCII/Unicode-Symbole, z.B. über SSH auf einer fremden Maschine.
if [[ -n "$KITTY_WINDOW_ID" || "$TERM_PROGRAM" == "WezTerm" || "$TERM_PROGRAM" == "ghostty" ]]; then
  typeset -g __prompt_icons=1
else
  typeset -g __prompt_icons=0
fi

if (( __prompt_icons )); then
  __prompt_host_icon=$' '   #  laptop
  __prompt_git_icon=$' '    #  git branch
  __prompt_home_icon=$''    #  home, ersetzt die führende Tilde im Pfad
  __prompt_arrow='❯❯'
else
  __prompt_host_icon=''
  __prompt_git_icon=''
  __prompt_home_icon='~'
  __prompt_arrow='>>'
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true          # nötig damit %u/%c überhaupt was anzeigen
zstyle ':vcs_info:git:*' stagedstr '✚'
zstyle ':vcs_info:git:*' unstagedstr '✱'
zstyle ':vcs_info:git:*' formats " %F{magenta}(${__prompt_git_icon}%b%u%c)%f"
zstyle ':vcs_info:git:*' actionformats " %F{magenta}(${__prompt_git_icon}%b|%a%u%c)%f"
zstyle ':vcs_info:*' enable git

precmd() {
  local exit_code=$?
  vcs_info
  # Pfeil wird rot wenn der letzte Befehl fehlgeschlagen ist
  if (( exit_code == 0 )); then
    prompt_arrow_color='%F{#FF0080}'
  else
    prompt_arrow_color='%F{red}'
  fi
  # %~ kürzt $HOME zu "~" -- das ersetzen wir durch das dezente Home-Icon
  # (bzw. im Fallback-Fall bleibt es einfach bei "~")
  prompt_path=${PWD/#$HOME/'~'}
  prompt_path=${prompt_path/#\~/$__prompt_home_icon}
}

# Prompt Definition (PS1) -- $'\n' MUSS außerhalb der einfachen Anführungszeichen stehen,
# sonst wird daraus kein echter Zeilenumbruch sondern der literale Text "$n"
PS1='%F{#FF0080}'"${__prompt_host_icon}"'%m%f'$'\n''%F{#F6AE2D}${prompt_path}%f${vcs_info_msg_0_} ${prompt_arrow_color}'"${__prompt_arrow}"'%f '

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
alias y='yazi'

alias l='eza --color=auto --icons=auto'
alias ll='eza -al --color=auto --icons=auto --git'
alias tree='eza --tree --color=auto --icons=auto'

alias b='bat'

alias reload='source ~/.zshrc'

# git (moderne switch/restore statt checkout)
alias gst='git status'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gsw='git switch'
alias gswc='git switch -c'
alias grs='git restore'
alias grss='git restore --staged'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'                    # tui: status/diff/log/stage/commit/push in einer ansicht
fi
if command -v git-absorb &> /dev/null; then
    alias gab='git absorb --and-rebase'   # staged änderungen automatisch als fixup! in die passenden commits einsortieren
fi

# fzf-gestützte git-funktionen (brauchen fzf, siehe unten)
if command -v fzf &> /dev/null; then
    # interaktiv branch wechseln (lokal + remote)
    fbr() {
        local branch
        branch=$(git branch --all --format='%(refname:short)' | grep -v HEAD | sort -u | fzf --height 40% --reverse) &&
        git switch "${branch#origin/}"
    }
    # interaktiv durch die commit-history browsen, mit live-vorschau des commits
    flog() {
        git log --oneline --graph --color=always |
        fzf --ansi --no-sort --reverse --height 60% \
            --preview 'git show --color=always $(grep -oE "[a-f0-9]{7,}" <<< {} | head -1)'
    }
fi

# cargo / rust
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'
alias cw='cargo watch -x check'

# kitty kittens
if command -v kitty &> /dev/null; then
    alias icat='kitty +kitten icat'          # bilder direkt im terminal anzeigen (z.b. simulator-screenshots)
    alias kdiff='kitty +kitten diff'         # schöner side-by-side diff mit syntax-highlighting
    alias kssh='kitty +kitten ssh'           # ssh mit korrektem terminfo/farben, kein "TERM unknown" auf dem remote
fi

eval "$(zoxide init zsh)"

# --- PATH Konfiguration ---
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
if [[ -d "$HOME/bin" ]] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi
if [[ -d "$HOME/.cargo/bin" ]] && [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
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

# fzf: Fuzzy-Suche für Ctrl+R (History), Ctrl+T (Dateien), Alt+C (Verzeichnisse)
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# direnv: lädt pro Verzeichnis automatisch eine .envrc (z.B. rust-toolchain/xcode-env je Projekt)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi
