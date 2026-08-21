# brewfile mit den wichtigsten sachen für die dev-umgebung auf macos.
# ausführen mit ./brew-setup.sh (nutzt "brew bundle", installiert nur was fehlt)
#
# eine kuratierte auswahl, ähnlich wie die pkglist für die arch-seite.

# === [ CORE & SHELL ] ===
brew "stow"                  # managed symlinks für die dotfiles
brew "zoxide"                 # schnelles verzeichnis-springen
brew "eza"                    # moderner ls-ersatz
brew "bat"                    # moderner cat-ersatz mit syntax-highlighting
brew "ripgrep"                # extrem schnelle textsuche (rg)
brew "fd"                     # schnellerer ersatz für find
brew "fzf"                    # fuzzy-suche für ctrl+r / dateien / cd
brew "direnv"                 # pro-projekt-ordner automatisch env-vars laden
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "fastfetch"              # systeminfos, obligatorischer ricing flex
brew "btop"                   # system monitor

# === [ EDITORS ] ===
cask "zed"                    # zed editor/ide, hauptsächlich benutzter editor
brew "helix"                  # terminal-editor für die schnellen zwischendurch-edits, config siehe helix/.config/helix
brew "micro"                  # simpler terminal-editor für quick edits

# === [ TERMINAL ] ===
cask "kitty"
cask "font-jetbrains-mono-nerd-font"   # brauchts für die icons im prompt/kitty

# === [ GLOBALE HOTKEYS ] ===
# einmalig vor dem ersten install nötig (neuere brew-versionen verlangen das
# für taps außerhalb von homebrew/core, siehe infos.dj):
#   brew tap koekeishiya/formulae
#   brew trust --formula koekeishiya/formulae/skhd
tap "koekeishiya/formulae"
brew "skhd"    # globaler hotkey-daemon, siehe skhd/.config/skhd/skhdrc (ALT+SPACE -> fzf-launcher)
brew "yabai"   # fenster query/focus fürs launcher-"fenster"-modus (kein SIP/scripting-addition nötig dafür)
brew "jq"      # json-parsing für den launcher-"fenster"-modus (yabai/hyprctl output)

# === [ RUST TOOLCHAIN ] ===
# rustup/cargo selbst NICHT über brew (läuft über rustup-init, siehe infos.dj),
# hier nur native build-dependencies die manche rust-crates brauchen:
brew "cmake"
brew "ninja"
brew "pkgconf"

# === [ MEDIA / DOKUMENTE ] ===
brew "mpv"                    # video player
brew "yazi"                   # terminal-dateibrowser
brew "poppler"                 # PDF-vorschau, z.b. in yazi
brew "pandoc"                  # dokumentenkonvertierung

# === [ GIT ] ===
brew "git-delta"               # syntax-highlighting-diffs als core.pager (siehe git/.config/git/config)
brew "lazygit"                 # tui für git
brew "git-absorb"              # verteilt staged änderungen automatisch als fixup! commits
brew "gh"                      # github cli (PRs/issues vom terminal aus)
