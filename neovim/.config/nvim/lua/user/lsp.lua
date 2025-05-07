local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_status_ok then
  vim.notify("lspconfig nicht gefunden!", vim.log.levels.WARN)
  return
end

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  vim.notify("nvim-cmp nicht gefunden!", vim.log.levels.WARN)
  return
end

-- Optional: Für Snippets mit Luasnip (falls du es in plugins.lua hinzugefügt hast)
-- local luasnip_status_ok, luasnip = pcall(require, "luasnip")
-- if not luasnip_status_ok then
--   vim.notify("luasnip nicht gefunden!", vim.log.levels.INFO)
-- end

local M = {}

M.setup = function()
  -- Eigene Handler für LSP-Nachrichten, um z.B. Icons anzuzeigen
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = true, -- Zeige Inline-Diagnosen an
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always", -- "always", "if_many"
      header = "",
      prefix = "",
    },
  })


  -- Keymaps für LSP-Funktionen
  -- Diese werden aufgerufen, wenn ein LSP-Server an den Buffer gebunden ist (on_attach)
  local on_attach = function(client, bufnr)
    vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
    end

    -- Grundlegende LSP-Aktionen
    map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
    map("n", "gr", vim.lsp.buf.references, "Go to References")
    map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
    map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
    map("n", "<leader>D", vim.lsp.buf.type_definition, "Type Definition")
    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help") -- Kann mit <C-k> für Fenster-Nav kollidieren
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    map("n", "gl", vim.diagnostic.open_float, "Line Diagnostics")
    map("n", "[d", vim.diagnostic.goto_prev, "Go to Previous Diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Go to Next Diagnostic")
    map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, "Format Code")

    -- Spezifische Client-Einstellungen (z.B. Root-Dir für bestimmte LSPs)
    -- if client.name == "tsserver" then
    --   client.server_capabilities.documentFormattingProvider = true -- enable format on save
    -- end
  end

  -- nvim-cmp Konfiguration
  cmp.setup({
    snippet = {
      -- Optional: Erweitere Snippets basierend auf der Snippet-Engine
      -- expand = function(args)
      --   if luasnip then
      --     luasnip.lsp_expand(args.body)
      --   end
      -- end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(), -- Manuelle Triggerung der Completion
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Bestätige mit Enter
      ["<Tab>"] = cmp.mapping(function(fallback) -- Tab zum Navigieren oder Fallback
        if cmp.visible() then
          cmp.select_next_item()
        -- elseif luasnip and luasnip.expand_or_jumpable() then -- Für Luasnip
        --   luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback) -- Shift-Tab zum Navigieren oder Fallback
        if cmp.visible() then
          cmp.select_prev_item()
        -- elseif luasnip and luasnip.jumpable(-1) then -- Für Luasnip
        --   luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      -- { name = "luasnip" }, -- Wenn Luasnip verwendet wird
      { name = "buffer" },
      { name = "path" },
    }),
    -- Für Icons bei den Completion-Vorschlägen (optional)
    formatting = {
      format = function(entry, vim_item)
          -- Icons für verschiedene Completion-Typen (benötigt Nerd Font)
          vim_item.kind = string.format('%s %s', require("user.lsp").kind_icons[vim_item.kind] or '', vim_item.kind)
          return vim_item
      end
    },
  })

  -- Zu installierende LSP-Server. Beispiele:
  -- Du musst diese Server manuell installieren (z.B. über Mason.nvim oder systemweit)
  -- oder Mason hier integrieren. Für Minimalismus lassen wir Mason erstmal weg.
  -- Stelle sicher, dass die Server im PATH sind.
  local servers = {
    "lua_ls", -- Für Lua (mit sumneko_lua)
    "bashls",
    "jsonls",
    "yamlls",
    "html",
    "cssls",
    "emmet_ls", -- Für HTML/CSS Emmet Support
    "pyright", -- Für Python
    "gopls",   -- Für Go
    "rust_analyzer", -- Für Rust
    -- Füge hier weitere LSP-Server hinzu, die du benötigst
    -- "tsserver", -- Für TypeScript/JavaScript
    -- "jdtls", -- Für Java
  }

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true -- Falls du Luasnip verwendest

  for _, server_name in ipairs(servers) do
    local server_opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    -- Spezifische Konfigurationen pro Server
    if server_name == "lua_ls" then
      server_opts.settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      }
    end
    if server_name == "rust_analyzer" then
        -- Keine spezielle Konfiguration nötig für den Start, RA ist gut out-of-the-box
    end
    lspconfig[server_name].setup(server_opts)
  end

  print("LSP-Konfiguration geladen.")
end

-- Icons für nvim-cmp (optional, benötigt Nerd Font)
M.kind_icons = {
  Text = "",
  Method = "",
  Function = "ƒ",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "",
  Interface = " interface",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = " enum",
  Keyword = "",
  Snippet = "snippet",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = " enum member",
  Constant = "constant",
  Struct = " struct",
  Event = " event",
  Operator = " operator",
  TypeParameter = " type parameter",
}


return M