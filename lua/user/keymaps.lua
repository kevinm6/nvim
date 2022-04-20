-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim & VimR
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/keymaps.lua
-- Last Modified: 15/04/2022 - 18:13
-------------------------------------

-- TODO: make improvements for new NeoVim 0.7

-- Function to make easy mapping in Lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.keymap
vim.g.mapleader = ","
vim.g.maplocalleader = ","


-- GUI
if vim.fn.has("gui_vimr") == 1 then -- VimR keymaps (command key and others)
	-- NORMAL-MODE
	keymap.set("n", "<D-Right>", "$", opts)
	keymap.set("n", "<D-Left>", "0", opts)
	keymap.set("n", "<D-Down>", "G", opts)
	keymap.set("n", "<D-Up>", "gg", opts)
	keymap.set("n", "<C-Tab>", "<cmd>bnext<cr>", opts)
	keymap.set("n", "<C-S-Tab>", "<cmd>bprevious<cr>", opts)
  -- move text
  keymap.set("n", "ª", ":move .+1<CR>==gi", opts) -- "ª" = "<A-j>"
  keymap.set("n", "º", ":move .-2<CR>==gi", opts) -- "º" = "<A-k>"

	-- INSERT-MODE
	keymap.set("i", "<D-BS>", "<C-u>", opts)
	keymap.set("i", "<D-Del>", [[<C-o>"_d$]], opts)
	keymap.set("i", "<D-Right>", "<Esc>A", opts)
	keymap.set("i", "<D-Left>", "<Esc>I", opts)
	keymap.set("i", "<D-Down>", "<Esc>Gi", opts)
	keymap.set("i", "<D-Up>", "<Esc>ggi", opts)
	keymap.set("i", "<M-BS>", "<C-w>", opts)
	keymap.set("i", "<M-Del>", [[<C-o>"_dw]], opts)

	-- VISUAL-MODE
	keymap.set("v", "<D-Right>", "$", opts)
	keymap.set("v", "<D-Left>", "0", opts)
	keymap.set("v", "<D-Down>", "G", opts)
	keymap.set("v", "<D-Up>", "gg", opts)
end

-- TERMINAL MODE
keymap.set("t", "<Esc>", "<C-\\><C-n>", term_opts)


-- INSERT MODE
keymap.set("i", "<S-Right>", "<C-o>vl", opts)
keymap.set("i", "<S-Left>", "<C-o>vh", opts)
keymap.set("i", "<S-Down>", "<C-o>vj", opts)
keymap.set("i", "<S-Up>", "<C-o>vk", opts)
keymap.set("i", "<M-Left>", "<C-o>b", opts)
keymap.set("i", "<M-Right>", "<C-o>w", opts)
keymap.set("i", "<Esc>", "<Esc>`^", opts)
keymap.set("i", "<F2>", [[<C-R>=strftime("%d/%m/%y - %H:%M")<CR>]], opts)
keymap.set("i", "jk", "<Esc>", opts)
keymap.set("i", "kj", "<Esc>", opts)
keymap.set("i", ",", ",<C-g>u", opts) -- checkpoints for undo
keymap.set("i", ".", ".<C-g>u", opts) -- checkpoints for undo

-- NORMAL MODE
keymap.set("n", "<M-Left>", "b", opts)
keymap.set("n", "<M-Right>", "E", opts)
keymap.set("n", "<S-Left>", "vh", opts)
keymap.set("n", "<S-Right>", "vl", opts)
keymap.set("n", "<S-Up>", "vk", opts)
keymap.set("n", "<S-Down>", "vj", opts)
keymap.set("n", "<C-h>", "<C-w>h", opts)
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<Nop>", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)
keymap.set("n", "<C-r>", "<cmd>redraw!<CR>", opts)
keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts)
keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts)
keymap.set("n", "<Esc>", "<cmd>noh<CR>", opts)
keymap.set("n", "Q", "<cmd>Bdelete<CR>", opts)
keymap.set("n", "U", "<C-r>", opts)
keymap.set("n", "Y", "y$", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)
keymap.set("n", "S", ":%s///<Left><Left>", { silent = false, noremap = true })
keymap.set("n", "µ", "<cmd>Glow<cr>", opts)
keymap.set("n", "Ú", "<C-w>| <C-w>_", opts)
keymap.set("n", "˝", "<C-W>J", opts)
keymap.set("n", "˛", "<C-W>K", opts)
keymap.set("n", "¸", "<C-W>H", opts)
keymap.set("n", "ˇ", "<C-W>L", opts)
keymap.set("n", "Ø", "O<Esc>j", opts)
keymap.set("n", "ø", "o<Esc>k", opts)
-- move text
keymap.set("n", "º", "<Esc>:m .-2<CR>==", opts)
keymap.set("n", "ª", "<Esc>:m .+1<CR>==", opts)

-- del.setete & cut
keymap.set("n", "x", [["_x]], opts)
keymap.set("n", "d", [["_d]], opts)
keymap.set("n", "D", [["_D]], opts)

-- VIS.setUAL MODE
keymap.set("v", "<M-Left>", "b", opts)
keymap.set("v", "<M-Right>", "w", opts)
keymap.set("v", "<BS>", [["_d]], opts)
keymap.set("v", "d", [["_d]], opts)
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
keymap.set("v", "p", "_dP", opts)

-- mov.sete selected text
keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap.set("x", "ª", ":move '>+1<CR>gv-gv", opts) -- <A-j>
keymap.set("x", "º", ":move '<-2<CR>gv-gv", opts) -- <A-k>

keymap.set("n", "p", "<Plug>(YankyPutAfter)", {})
keymap.set("n", "P", "<Plug>(YankyPutBefore)", {})
keymap.set("x", "p", "<Plug>(YankyPutAfter)", {})
keymap.set("x", "P", "<Plug>(YankyPutBefore)", {})
keymap.set("n", "gp", "<Plug>(YankyGPutAfter)", {})
keymap.set("n", "gP", "<Plug>(YankyGPutBefore)", {})
keymap.set("x", "gp", "<Plug>(YankyGPutAfter)", {})
keymap.set("x", "gP", "<Plug>(YankyGPutBefore)", {})

