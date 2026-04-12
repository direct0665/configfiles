# pauls config

schnelle arch hyprland config

## setup

1. repo klonen: `git clone https://github.com/direct0665/configfiles ~/dotfiles`
2. skript `setup.sh` starten. das aktiviert darkmode, platziert die dotfiles mit stow etc, aktiviert zsh
3. updates: einfach `git pull` im dotfiles ordner ausführen

## keybinds hyprland

main-key ist die windows-taste (super).

- `super + return` : terminal (kitty)
- `super + c` : fenster schließen
- `super + r` : app-starter (wofi)
- `super + y` : lockscreen
- `super + m` : logout
- `super + f` : firefox
- `super + e` : dolphin (file manager)
- `super + x` : magic menu (nicht magic aber öffnet wofi mit einer auswahl an skripten und shortcuts)
- `super + pfeiltasten` : fokus bewegen
- `super + 1-0` : workspace wechseln
- `super + shift + 1-0` : verschiebt das aktive fenster auf den entsprechenden workspace

## terminal & aliase

- `y` : yazi (dateimanager, merkt sich den pfad)
- `z` : zoxide (schnelles cd in bekannte ordner)
- `hx` : helix (editor)
- `lg` : lazygit (git tui)
- `upd`: alias für `yay -Syu`

## media & docs

- yazi: `pfeile` zum navigieren, `enter` zum öffnen, `q` zum beenden.
- imv (bilder): `pfeile` zum blättern, `q` zum schließen.
- mpv (video): `space` für pause, `f` für fullsreen.
- zathura (pdf): `j / k` zum scrollen, `r` für rotation. lädt typst automatisch neu.

## pkglist

in der `pkglist` stehen alle standardprogramme mit beschreibung. es gibt ein skript das über das magic menu aufgerufen werden kann das alle einträge davon installiert. das ist auch beim setup skript wählbar.


## allgemeine hinweise
- hyprland wird automatisch beim ersten login in shell 1 geöffnet, öffnet sich aber nicht ständig automatisch wieder. deswegen gibt es in dem setup keinen login manager
- darkmode bei manchen apps macht was er will und nicht was er soll idk warum
