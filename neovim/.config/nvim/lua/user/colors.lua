-- Definiere deine Farbpalette
local palette = {
    pink = "#FF0080",
    dark_green = "#023C40",
    light_green = "#AEFFD8",
    orange = "#F6AE2D",
    dark_red = "#4A051C",
    -- Weitere Basisfarben für ein Theme
    background = "#1E1E2E", -- Beispiel Dunkelblau/Grau
    foreground = "#CDD6F4", -- Beispiel Helles Lavendel
    comment = "#6C7086",    -- Beispiel Grau
    cyan = "#89B4FA",
    green = "#A6E3A1",
    yellow = "#F9E2AF",
    red = "#F38BA8",
    blue = "#89B4FA",
    magenta = palette.pink, -- Verwende deine pinke Farbe
  }
  
  -- Funktion zum Setzen von Highlights
  local function set_highlights()
    vim.cmd("hi clear") -- Lösche existierende Highlights
    if vim.fn.exists("syntax_on") then
      vim.cmd("syntax reset")
    end
    vim.o.background = "dark" -- oder "light", je nachdem
  
    local highlights = {
      -- Allgemeine UI Elemente
      Normal = { fg = palette.foreground, bg = palette.background },
      Visual = { bg = palette.dark_green, fg = palette.light_green },
      CursorLine = { bg = "#282A36" }, -- Etwas dunklerer Hintergrund für die Cursorzeile
      LineNr = { fg = palette.comment },
      SignColumn = { fg = palette.comment },
      StatusLine = { fg = palette.light_green, bg = palette.dark_green },
      StatusLineNC = { fg = palette.comment, bg = "#282A36" },
      TabLine = { fg = palette.comment, bg = "#282A36" },
      TabLineFill = { bg = "#282A36" },
      TabLineSel = { fg = palette.light_green, bg = palette.dark_green },
      VertSplit = { fg = palette.dark_green },
  
      -- Syntax Highlighting
      Comment = { fg = palette.comment, italic = true },
      Constant = { fg = palette.orange },
      String = { fg = palette.light_green },
      Character = { fg = palette.light_green },
      Number = { fg = palette.orange },
      Boolean = { fg = palette.orange },
      Float = { fg = palette.orange },
  
      Identifier = { fg = palette.blue },
      Function = { fg = palette.pink, bold = true }, -- Dein Pink für Funktionen
      Statement = { fg = palette.pink },
      Conditional = { fg = palette.pink, italic = true },
      Repeat = { fg = palette.pink, italic = true },
      Label = { fg = palette.orange },
      Operator = { fg = palette.foreground },
      Keyword = { fg = palette.dark_red, bold = true }, -- Dein Dunkelrot für Keywords
      Exception = { fg = palette.pink },
  
      PreProc = { fg = palette.yellow },
      Include = { fg = palette.blue },
      Define = { fg = palette.yellow },
      Macro = { fg = palette.yellow },
  
      Type = { fg = palette.cyan },
      StorageClass = { fg = palette.cyan, italic = true },
      Structure = { fg = palette.cyan },
      Typedef = { fg = palette.cyan, bold = true },
  
      Title = { fg = palette.pink, bold = true },
      Underlined = { underline = true },
      Error = { fg = palette.red, bg = palette.background, bold = true },
      Todo = { fg = palette.background, bg = palette.orange, bold = true },
      Search = { bg = palette.yellow, fg = palette.background },
  
      -- LSP Highlighting
      LspDiagnosticsDefaultError = { fg = palette.red },
      LspDiagnosticsDefaultWarning = { fg = palette.yellow },
      LspDiagnosticsDefaultInformation = { fg = palette.blue },
      LspDiagnosticsDefaultHint = { fg = palette.cyan },
      LspDiagnosticsUnderlineError = { undercurl = true, sp = palette.red },
      LspDiagnosticsUnderlineWarning = { undercurl = true, sp = palette.yellow },
      LspDiagnosticsUnderlineInformation = { undercurl = true, sp = palette.blue },
      LspDiagnosticsUnderlineHint = { undercurl = true, sp = palette.cyan },
  
      -- Telescope
      TelescopeNormal = { fg = palette.foreground, bg = palette.background },
      TelescopeBorder = { fg = palette.dark_green, bg = palette.background },
      TelescopePromptBorder = { fg = palette.pink, bg = palette.background },
      TelescopeResultsBorder = { fg = palette.dark_green, bg = palette.background },
      TelescopePreviewBorder = { fg = palette.dark_green, bg = palette.background },
      TelescopeSelection = { bg = palette.dark_green, fg = palette.light_green, bold = true },
  
      -- Treesitter (kann von den obigen erben, aber spezifische Gruppen können auch gesetzt werden)
      ["@variable"] = { fg = palette.blue },
      ["@variable.builtin"] = { fg = palette.cyan, italic = true },
      ["@constant"] = { fg = palette.orange },
      ["@constant.builtin"] = { fg = palette.orange, italic = true },
      ["@module"] = { fg = palette.cyan },
      ["@label"] = { fg = palette.orange },
  
      ["@string"] = { fg = palette.light_green },
      ["@string.regex"] = { fg = palette.yellow },
      ["@string.escape"] = { fg = palette.pink },
  
      ["@character"] = { fg = palette.light_green },
      ["@character.special"] = { fg = palette.pink },
  
      ["@boolean"] = { fg = palette.orange },
      ["@number"] = { fg = palette.orange },
      ["@float"] = { fg = palette.orange },
  
      ["@function"] = { fg = palette.pink },
      ["@function.builtin"] = { fg = palette.pink, italic = true },
      ["@function.macro"] = { fg = palette.yellow },
      ["@method"] = { fg = palette.pink },
      ["@constructor"] = { fg = palette.cyan },
      ["@operator"] = { fg = palette.foreground },
  
      ["@keyword"] = { fg = palette.dark_red, bold = true },
      ["@keyword.function"] = { fg = palette.dark_red, italic = true },
      ["@keyword.operator"] = { fg = palette.dark_red },
      ["@keyword.return"] = { fg = palette.pink, bold = true },
  
      ["@conditional"] = { fg = palette.pink, italic = true },
      ["@repeat"] = { fg = palette.pink, italic = true },
      ["@exception"] = { fg = palette.pink },
  
      ["@punctuation.delimiter"] = { fg = palette.foreground },
      ["@punctuation.bracket"] = { fg = palette.foreground },
      ["@punctuation.special"] = { fg = palette.pink },
  
      ["@comment"] = { fg = palette.comment, italic = true },
      ["@comment.error"] = { fg = palette.red, bg = palette.background, italic = true },
      ["@comment.warning"] = { fg = palette.yellow, bg = palette.background, italic = true },
      ["@comment.todo"] = { fg = palette.orange, bg = palette.background, bold = true, italic = true },
      ["@comment.note"] = { fg = palette.blue, bg = palette.background, italic = true },
  
      ["@type"] = { fg = palette.cyan },
      ["@type.builtin"] = { fg = palette.cyan, italic = true },
      ["@type.definition"] = { fg = palette.cyan, bold = true },
  
      ["@tag"] = { fg = palette.blue },
      ["@tag.attribute"] = { fg = palette.orange },
      ["@tag.delimiter"] = { fg = palette.foreground },
  
      ["@text.title"] = { fg = palette.pink, bold = true },
      ["@text.literal"] = { fg = palette.light_green },
      ["@text.uri"] = { fg = palette.blue, underline = true },
      ["@text.emphasis"] = { italic = true },
      ["@text.strong"] = { bold = true },
      ["@text.strike"] = { strikethrough = true },
    }
  
    for group, settings in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, settings)
    end
  
    -- Spezifische Anpassungen für Plugins
    -- z.B. für vim-substitute (Standardfarben sind oft OK, aber hier ein Beispiel)
    vim.api.nvim_set_hl(0, "Substitute퍄", { bg = palette.orange, fg = palette.background })
    vim.api.nvim_set_hl(0, "SubstituteMyaso", { bg = palette.dark_green, fg = palette.light_green })
  end
  
  set_highlights()
  
  -- Automatisches Neuladen der Farben bei Schema-Änderung (optional)
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      set_highlights()
    end,
  })