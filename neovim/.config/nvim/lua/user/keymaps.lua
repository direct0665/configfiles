local map = vim.keymap.set
local nomap = vim.keymap.del
local opts = { noremap = true, silent = true }

-- Leader-Key setzen (häufig Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Grundlegende Mappings
map("n", "<Esc>", "<cmd>noh<CR><Esc>", { desc = "Escape and clear hlsearch" }) -- Escape löscht auch Suchhervorhebung
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write (save) file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })

-- Fenster-Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate window right" })

-- Buffer-Navigation (Beispiel)
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

-- Editieren
map("i", "jk", "<Esc>", opts) -- Schnelles Verlassen des Insert-Modus
map("i", "kj", "<Esc>", opts)

-- Terminal (Beispiel)
map("n", "<leader>tt", "<cmd>toggleterm<CR>", { desc = "Toggle terminal" }) -- Benötigt z.B. toggleterm.nvim

-- Plugin-spezifische Mappings werden in den jeweiligen Plugin-Konfigurationen oder hier zentral gesetzt

-- Telescope Mappings (Beispiele, werden auch in telescope.lua gesetzt)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- LSP Keymaps (Beispiele, werden auch in lsp.lua gesetzt)
-- Siehe lsp.lua für Details

-- Substitute.nvim (Standardmappings sind oft <leader>s)
-- Das Plugin stellt eigene Mappings bereit, die meistens gut sind.
-- map("n", "<leader>s", "<cmd>lua require('substitute').operator()<CR>", { desc = "Substitute with motion" })
-- map("n", "ss", "<cmd>lua require('substitute').line()<CR>", { desc = "Substitute line" })
-- map("x", "<leader>s", "<cmd>lua require('substitute').visual()<CR>", { desc = "Substitute visual selection" })

print("Keymaps geladen.")