-- Globale Optionen (Beispiele)
vim.opt.termguicolors = true -- Wichtig für eigene Farben
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.mouse = 'a' -- Mausunterstützung aktivieren
vim.opt.clipboard = 'unnamedplus' -- System-Zwischenablage nutzen

-- Schriftart setzen
vim.opt.guifont = "DejaVuSansM Nerd Font Mono:h10" -- :h10 ist die Schriftgröße, passe sie bei Bedarf an

-- Lade Farbdefinitionen
require("user.colors")

-- Lade Keymaps
require("user.keymaps")

-- Lade Plugins
require("user.plugins")

-- Lade LSP-Konfiguration
require("user.lsp")

-- Lade Treesitter-Konfiguration
require("user.treesitter")

-- Lade Telescope-Konfiguration
require("user.telescope")

print("Neovim Konfiguration geladen!")