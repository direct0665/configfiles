# djot syntax für bat

`Djot.sublime-syntax` kommt von [sorairolake/djot.sublime-syntax](https://github.com/sorairolake/djot.sublime-syntax)
(archiviert, stand feb 2023), lizenz siehe `COPYRIGHT` / `LICENSE-MIT` / `LICENSE-CC0`.

nach jedem update dieser datei (oder neuinstallation von bat) einmal `bat cache --build` laufen lassen,
sonst greift die neue syntax nicht.

## caveat

die grammatik ist auf dem djot-spec-stand von feb 2023 eingefroren (repo wurde danach nie wieder
angefasst und ist jetzt archiviert). djot selbst hat sich seitdem weiterentwickelt, könnte also sein
dass neuere syntax (z.b. attribute vor fenced divs) nicht sauber highlighted wird, obwohl `jotdown`
sie längst korrekt parst. im zweifel `jotdown` als quelle der wahrheit nehmen, nicht bat.
