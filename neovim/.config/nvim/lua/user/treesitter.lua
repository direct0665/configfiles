local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("nvim-treesitter.configs nicht gefunden!", vim.log.levels.WARN)
  return
end

local M = {}

M.setup = function()
  treesitter_configs.setup({
    -- Liste der zu installierenden Parser. :TSInstall <sprache> installiert sie manuell.
    ensure_installed = {
      "c", "cpp", "go", "lua", "python", "rust", "tsx", "javascript", "typescript",
      "json", "yaml", "html", "css", "bash", "markdown", "markdown_inline", "query", "vim", "vimdoc"
    },

    -- Installiere Parser synchron (blockierend)
    sync_install = false,

    -- Automatisch neue Parser installieren (empfohlen: false, um Kontrolle zu behalten)
    auto_install = false,

    -- Treesitter Module und deren Konfigurationen
    highlight = {
      enable = true, -- Syntax Highlighting aktivieren
      -- disable = { "c", "rust" }, -- Bestimmte Sprachen vom Highlighting ausschließen
      -- Zusätzliche Highlight-Gruppen (für mehr Granularität)
      -- additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true, -- Bessere Einrückung basierend auf Treesitter
      -- disable = { "yaml" },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>", -- Beginne Auswahl mit Enter im Normal-Modus
        node_incremental = "<CR>", -- Erweitere Auswahl zum nächsten Knoten
        scope_incremental = "<S-CR>", -- Erweitere Auswahl zum nächsten Scope
        node_decremental = "<BS>", -- Verkleinere Auswahl
      },
    },
    -- Weitere Module wie textobjects, etc. können hier aktiviert werden.
    -- textobjects = {
    --   select = {
    --     enable = true,
    --     lookahead = true, -- Wichtig für konsistente Auswahl
    --     keymaps = {
    --       -- Beispiel: Wähle um eine Funktion herum
    --       ["af"] = "@function.outer",
    --       ["if"] = "@function.inner",
    --       -- Wähle um eine Klasse herum
    --       ["ac"] = "@class.outer",
    --       ["ic"] = "@class.inner",
    --     },
    --   },
    -- },
  })
  print("Treesitter-Konfiguration geladen.")
end

return M