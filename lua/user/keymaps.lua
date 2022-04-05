-------------------------------------
-- File: keymaps.lua
-- Description: Keymaps for NeoVim & VimR
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/keymaps.lua
-- Last Modified: 04/04/2022 - 10:46
-------------------------------------


-- Function to make easy mapping in Lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","


-- GUI
if vim.fn.has("gui_vimr") == 1 then -- VimR keymaps (command key and others)
	-- NORMAL-MODE
	keymap("n", "<D-Right>", "$", opts)
	keymap("n", "<D-Left>", "0", opts)
	keymap("n", "<D-Down>", "G", opts)
	keymap("n", "<D-Up>", "gg", opts)
	keymap("n", "<C-Tab>", "<cmd>bnext<cr>", opts)
	keymap("n", "<C-S-Tab>", "<cmd>bprevious<cr>", opts)
  -- move text
  keymap("n", "ª", ":move .+1<CR>==gi", opts) -- "ª" = "<A-j>"
  keymap("n", "º", ":move .-2<CR>==gi", opts) -- "º" = "<A-k>"

	-- INSERT-MODE
	keymap("i", "<D-BS>", "<C-u>", opts)
	keymap("i", "<D-Del>", [[<C-o>"_d$]], opts)
	keymap("i", "<D-Right>", "<Esc>A", opts)
	keymap("i", "<D-Left>", "<Esc>I", opts)
	keymap("i", "<D-Down>", "<Esc>Gi", opts)
	keymap("i", "<D-Up>", "<Esc>ggi", opts)
	keymap("i", "<M-BS>", "<C-w>", opts)
	keymap("i", "<M-Del>", [[<C-o>"_dw]], opts)

	-- VISUAL-MODE
	keymap("v", "<D-Right>", "$", opts)
	keymap("v", "<D-Left>", "0", opts)
	keymap("v", "<D-Down>", "G", opts)
	keymap("v", "<D-Up>", "gg", opts)
end

-- TERMINAL MODE
keymap("t", "<Esc>", "<C-\\><C-n>", term_opts)


-- INSERT MODE
keymap("i", "<S-Right>", "<C-o>vl", opts)
keymap("i", "<S-Left>", "<C-o>vh", opts)
keymap("i", "<S-Down>", "<C-o>vj", opts)
keymap("i", "<S-Up>", "<C-o>vk", opts)
keymap("i", "<M-Left>", "<C-o>b", opts)
keymap("i", "<M-Right>", "<C-o>w", opts)
keymap("i", "<Esc>", "<Esc>`^", opts)
keymap("i", "<F2>", [[<C-R>=strftime("%d/%m/%y - %H:%M")<CR>]], opts)
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)
keymap("i", ",", ",<C-g>u", opts) -- checkpoints for undo
keymap("i", ".", ".<C-g>u", opts) -- checkpoints for undo

-- NORMAL MODE
keymap("n", "<M-Left>", "b", opts)
keymap("n", "<M-Right>", "E", opts)
keymap("n", "<S-Left>", "vh", opts)
keymap("n", "<S-Right>", "vl", opts)
keymap("n", "<S-Up>", "vk", opts)
keymap("n", "<S-Down>", "vj", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<Nop>", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-r>", "<cmd>redraw!<CR>", opts)
keymap("n", "<S-l>", "<cmd>bnext<CR>", opts)
keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts)
keymap("n", "<Esc>", "<cmd>noh<CR>", opts)
keymap("n", "Q", "<cmd>Bdelete<CR>", opts)
keymap("n", "U", "<C-r>", opts)
keymap("n", "Y", "y$", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "S", ":%s///<Left><Left>", { silent = false, noremap = true })
keymap("n", "µ", "<cmd>Glow<cr>", opts)
keymap("n", "Ú", "<C-w>| <C-w>_", opts)
keymap("n", "˝", "<C-W>J", opts)
keymap("n", "˛", "<C-W>K", opts)
keymap("n", "¸", "<C-W>H", opts)
keymap("n", "ˇ", "<C-W>L", opts)
keymap("n", "Ø", "O<Esc>j", opts)
keymap("n", "ø", "o<Esc>k", opts)
-- move text
keymap("n", "º", "<Esc>:m .-2<CR>==", opts)
keymap("n", "ª", "<Esc>:m .+1<CR>==", opts)

-- delete & cut
keymap("n", "x", [["_x]], opts)
keymap("n", "d", [["_d]], opts)
keymap("n", "D", [["_D]], opts)

-- VISUAL MODE
keymap("v", "<M-Left>", "b", opts)
keymap("v", "<M-Right>", "w", opts)
keymap("v", "<BS>", [["_d]], opts)
keymap("v", "d", [["_d]], opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "p", "_dP", opts)

-- move selected text
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "ª", ":move '>+1<CR>gv-gv", opts) -- <A-j>
keymap("x", "º", ":move '<-2<CR>gv-gv", opts) -- <A-k>
