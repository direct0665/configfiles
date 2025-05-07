local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  error("lazy.nvim not found. Please ensure lazy-bootstrap.lua ran correctly or install it manually.")
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Kern-Plugin-Manager
  "folke/lazy.nvim",

  -- Abhängigkeiten (oft von anderen Plugins benötigt)
  "nvim-lua/plenary.nvim", -- Nützliche Lua Funktionen, von Telescope etc. benötigt
  "nvim-tree/nvim-web-devicons", -- Für Icons in Telescope etc. (optional, aber nett)

  -- LSP Konfiguration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Lade verzögert
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Autocompletion Source für LSP
      "hrsh7th/cmp-buffer",   -- Autocompletion Source für Buffer-Wörter
      "hrsh7th/nvim-cmp",     -- Autocompletion Engine
      -- Optional: Snippet Engine (z.B. luasnip)
      -- "L3MON4D3/LuaSnip",
      -- "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("user.lsp").setup()
    end,
  },

  -- Treesitter für Syntax Highlighting und mehr
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatisch Parser aktualisieren/installieren
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("user.treesitter").setup()
    end,
  },

  -- Telescope für Fuzzy Finding
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- Lade, wenn Telescope-Kommando ausgeführt wird
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("user.telescope").setup()
    end,
  },
  -- Optional: telescope-fzf-native für schnellere Sortierung (benötigt C-Compiler)
  -- {
  --   "nvim-telescope/telescope-fzf-native.nvim",
  --   build = "make",
  --   cond = function()
  --     return vim.fn.executable("make") == 1
  --   end,
  -- },


  -- Substitute.nvim
  {
    "gbprod/substitute.nvim",
    event = "VeryLazy",
    config = function()
      require("substitute").setup({
        -- on_substitute = nil, -- Callback nach dem Ersetzen
        --yank_substituted_text = false, -- Geänderten Text nicht automatisch yanken
        -- highlight_substituted_text = { -- Wie der ersetzte Text hervorgehoben wird
        --   enabled = true,
        --   timer = 500,
        -- },
        -- range = {
        --   prefix = "s", -- z.B. :s/foo/bar
        --   complete = "cmdline", -- oder "wildmenu"
        --   confirm = false, -- Jede Ersetzung bestätigen
        --   sep = "/", -- Trennzeichen
        --   modifiers = "[gciI]", -- Standard-Modifier
        --   sla = false, -- Smart /s -> /
        -- },
        exchange = {
          motion = false, -- ob cx auf motion basiert
          reselect = true, -- nach Austausch erneut auswählen
        },
      })
      -- Eigene Mappings für substitute.nvim, falls gewünscht (Standard ist <leader>s)
      vim.keymap.set("n", "<leader>s", require("substitute").operator, { desc = "Substitute with motion" })
      vim.keymap.set("n", "ss", require("substitute").line, { desc = "Substitute current line" })
      vim.keymap.set("n", "<leader>S", require("substitute").eol, { desc = "Substitute to end of line" })
      vim.keymap.set("x", "<leader>s", require("substitute").visual, { desc = "Substitute visual selection" })
    end,
  },

  -- Für "Standard Keybindings" (optional, wenn du mehr als die Basics willst)
  -- {
  -- "tpope/vim-sensible",
  -- event = "VeryLazy",
  -- },
  -- Oder eine Alternative wie:
  -- {
  -- "folke/which-key.nvim", -- Zeigt mögliche Keybindings an
  -- event = "VeryLazy",
  -- config = function()
  -- require("which-key").setup({})
  -- end,
  -- },

  -- Autocompletion (nvim-cmp)
  -- Bereits oben als Abhängigkeit von lspconfig definiert, hier nur falls du es separat konfigurieren willst.
  -- {
  --   "hrsh7th/nvim-cmp",
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     -- "L3MON4D3/LuaSnip", -- Wenn Snippets gewünscht sind
  --     -- "saadparwaiz1/cmp_luasnip",
  --   },
  --   config = function()
  --     -- Die cmp-Konfiguration ist Teil der lsp.lua
  --   end,
  -- },

}

require("lazy").setup(plugins, {
  -- Standardoptionen für lazy.nvim (optional)
  -- performance = {
  --   rtp = {
  --     -- Warnung, wenn die Laufzeitpfad-Manipulation lange dauert
  --     disabled_plugins = {
  --       -- "gzip",
  --       -- "matchit",
  --       -- "matchparen",
  --       -- "netrwPlugin",
  --       -- "tarPlugin",
  --       -- "tohtml",
  --       -- "tutor",
  --       -- "zipPlugin",
  --     },
  --   },
  -- },
  install = {
    colorscheme = { "default" }, -- Kein spezifisches Farbschema von lazy.nvim installieren
  },
  checker = {
    enabled = true,
    notify = true, -- Benachrichtigen, wenn Updates verfügbar sind
  },
  change_detection = {
    enabled = true,
    notify = true, -- Benachrichtigen, wenn Änderungen an Plugin-Dateien erkannt werden
  },
})

print("Plugins geladen via lazy.nvim.")