local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("telescope nicht gefunden!", vim.log.levels.WARN)
  return
end

local actions_status_ok, actions = pcall(require, "telescope.actions")
if not actions_status_ok then
  vim.notify("telescope.actions nicht gefunden!", vim.log.levels.WARN)
  return
end

local M = {}

M.setup = function()
  telescope.setup({
    defaults = {
      prompt_prefix = "  ", -- Nerd Font Icon für Suche (optional)
      selection_caret = " ", -- Nerd Font Icon für Auswahl (optional)
      path_display = { "truncate" }, -- Wie Pfade angezeigt werden
      layout_strategy = "horizontal", -- oder "vertical", "flex"
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      sorting_strategy = "ascending",
      mappings = {
        i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next, -- Alternative zu C-n
          ["<C-k>"] = actions.move_selection_previous, -- Alternative zu C-p
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["<CR>"] = actions.select_default,
          ["<Esc>"] = actions.close,
          -- Weitere Mappings nach Bedarf
        },
        n = {
          ["<CR>"] = actions.select_default,
          ["<Esc>"] = actions.close,
          ["q"] = actions.close,
          ["dd"] = actions.delete_buffer,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          -- Weitere Mappings nach Bedarf
        },
      },
      -- Weitere Standardeinstellungen hier...
    },
    pickers = {
      -- Konfiguration für spezifische Picker (z.B. find_files, live_grep)
      find_files = {
        -- theme = "dropdown", -- Beispiel für ein anderes Theme
        hidden = true, -- Versteckte Dateien anzeigen
        -- no_ignore = false, -- .gitignore etc. beachten
      },
      live_grep = {
        -- theme = "ivy",
      },
      buffers = {
        show_all_buffers = true,
        sort_mru = true,
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
    },
    extensions = {
      -- Konfiguration für Telescope-Erweiterungen, z.B. fzf-native
      -- fzf = {
      --   fuzzy = true,                    -- Enable fuzzy finding
      --   override_generic_sorter = true,  -- Override the generic sorter
      --   override_file_sorter = true,     -- Override the file sorter
      --   case_mode = "smart_case",        -- Or "ignore_case", "respect_case"
      -- },
    },
  })

  -- Optional: Lade fzf-native Erweiterung, falls in plugins.lua definiert
  -- pcall(telescope.load_extension, "fzf")

  -- Keymaps für Telescope (zentral hier oder in keymaps.lua)
  local map = vim.keymap.set
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
  map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
  map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find oldfiles (recent)" })
  map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Fuzzy find in current buffer" })
  map("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
  map("n", "<leader>/", function() -- Grep für das Wort unter dem Cursor
    telescope.extensions.grep_string.grep_string()
  end, { desc = "Grep string under cursor" })


  print("Telescope-Konfiguration geladen.")
end

return M