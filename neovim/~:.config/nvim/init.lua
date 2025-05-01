-- ~/.config/nvim/init.lua
-- Minimale Neovim Konfiguration mit lazy.nvim

--[[

  Installation von lazy.nvim (falls noch nicht geschehen):
  1. Stelle sicher, dass Neovim v0.8.0+ installiert ist.
  2. Stelle sicher, dass `git` installiert ist.
  3. Führe Neovim aus. Der Code unten wird lazy.nvim automatisch herunterladen und installieren.

--]]

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installiere lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- Füge lazy.nvim zum Runtime Path hinzu

-- Grundlegende Neovim Optionen
vim.opt.termguicolors = true -- Aktiviere True Color Unterstützung im Terminal
vim.opt.number = true        -- Zeilennummern anzeigen
vim.opt.relativenumber = true -- Relative Zeilennummern anzeigen
vim.opt.expandtab = true     -- Tabs durch Leerzeichen ersetzen
vim.opt.shiftwidth = 2       -- Anzahl der Leerzeichen für Einrückungen
vim.opt.tabstop = 2          -- Anzahl der Leerzeichen für einen Tabstop
vim.opt.softtabstop = 2      -- Anzahl der Leerzeichen für Soft-Tabstops
vim.opt.ignorecase = true    -- Groß-/Kleinschreibung bei Suche ignorieren
vim.opt.smartcase = true     -- Groß-/Kleinschreibung beachten, wenn Großbuchstaben im Suchmuster vorkommen
vim.opt.wrap = false         -- Zeilenumbruch deaktivieren
vim.opt.swapfile = false     -- Keine Swap-Dateien erstellen
vim.opt.backup = false       -- Keine Backup-Dateien erstellen
vim.opt.undofile = true      -- Undo-Verlauf persistent speichern
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Speicherort für Undo-Dateien
if not vim.loop.fs_stat(vim.opt.undodir:get()) then
    vim.fn.mkdir(vim.opt.undodir:get(), "p")
end

vim.g.mapleader = " " -- Setze den Leader Key auf Leerzeichen (üblich)

-- Lade lazy.nvim und konfiguriere Plugins
-- Füge deine Plugins innerhalb der geschweiften Klammern {} hinzu
require("lazy").setup({
  -- Beispiel-Plugin (optional, zum Testen einkommentieren):
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false, -- Sofort laden
  --   priority = 1000, -- Hohe Priorität, damit es früh geladen wird
  --   config = function()
  --     -- Lade das Farbschema
  --     vim.cmd.colorscheme("tokyonight")
  --     print("Tokyonight Farbschema geladen!")
  --   end,
  -- },

  -- Füge hier weitere Plugins hinzu, z.B.:
  -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- { "nvim-telescope/telescope.nvim", tag = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  -- { "hrsh7th/nvim-cmp", dependencies = { ... } },

})

print("Neovim Konfiguration geladen!")

