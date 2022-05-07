-------------------------------------
-- File         : keymaps.lua
-- Description  : Keymaps for NeoVim & VimR
-- Author       : Kevin
-- Last Modified: 28/04/2022 - 13:39
-------------------------------------

-- Function to make easier mapping in Lua
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local set_keymap = vim.keymap.set
vim.g.mapleader = ","
vim.g.maplocalleader = ","


-- GUI
-- VimR keymaps (command key and others)
if vim.fn.has "gui_vimr" == 1 then
	-- NORMAL-MODE
	set_keymap("n", "<D-Right>", "$", opts)
	set_keymap("n", "<D-Left>", "0", opts)
	set_keymap("n", "<D-Down>", "G", opts)
	set_keymap("n", "<D-Up>", "gg", opts)
	set_keymap("n", "<C-Tab>", "<cmd>bnext<cr>", opts)
	set_keymap("n", "<C-S-Tab>", "<cmd>bprevious<cr>", opts)
  -- move text
  set_keymap("n", "ª", ":move .+1<CR>==gi", opts) -- "ª" = "<A-j>"
  set_keymap("n", "º", ":move .-2<CR>==gi", opts) -- "º" = "<A-k>"

	-- INSERT-MODE
	set_keymap("i", "<D-BS>", "<C-u>", opts)
	set_keymap("i", "<D-Del>", [[<C-o>"_d$]], opts)
	set_keymap("i", "<D-Right>", "<Esc>A", opts)
	set_keymap("i", "<D-Left>", "<Esc>I", opts)
	set_keymap("i", "<D-Down>", "<Esc>Gi", opts)
	set_keymap("i", "<D-Up>", "<Esc>ggi", opts)
	set_keymap("i", "<M-BS>", "<C-w>", opts)
	set_keymap("i", "<M-Del>", [[<C-o>"_dw]], opts)

	-- VISUAL-MODE
	set_keymap("v", "<D-Right>", "$", opts)
	set_keymap("v", "<D-Left>", "0", opts)
	set_keymap("v", "<D-Down>", "G", opts)
	set_keymap("v", "<D-Up>", "gg", opts)
end

-- TERMINAL MODE
set_keymap("t", "<Esc>", "<C-\\><C-n>", term_opts)


-- INSERT MODE
set_keymap("i", "<S-Right>", "<C-o>vl", opts)
set_keymap("i", "<S-Left>", "<C-o>vh", opts)
set_keymap("i", "<S-Down>", "<C-o>vj", opts)
set_keymap("i", "<S-Up>", "<C-o>vk", opts)
set_keymap("i", "<M-Left>", "<C-o>b", opts)
set_keymap("i", "<M-Right>", "<C-o>w", opts)
set_keymap("i", "<Esc>", "<Esc>`^", opts)
set_keymap("i", "<F2>", [[<C-R>=strftime("%d/%m/%y - %H:%M")<CR>]], opts)
set_keymap("i", "jk", "<Esc>", opts)
set_keymap("i", "kj", "<Esc>", opts)
set_keymap("i", ",", ",<C-g>u", opts) -- checkpoints for undo
set_keymap("i", ".", ".<C-g>u", opts) -- checkpoints for undo

-- NORMAL MODE
set_keymap("n", "<M-Left>", "b", opts)
set_keymap("n", "<M-Right>", "E", opts)
set_keymap("n", "<S-Left>", "vh", opts)
set_keymap("n", "<S-Right>", "vl", opts)
set_keymap("n", "<S-Up>", "vk", opts)
set_keymap("n", "<S-Down>", "vj", opts)
set_keymap("n", "<C-h>", "<C-w>h", opts)
set_keymap("n", "<C-j>", "<C-w>j", opts)
set_keymap("n", "<C-k>", "<C-w>k", opts)
set_keymap("n", "<C-l>", "<Nop>", opts)
set_keymap("n", "<C-l>", "<C-w>l", opts)
set_keymap("n", "<C-r>", "<cmd>redraw!<CR>", opts)
set_keymap("n", "<S-l>", "<cmd>bnext<CR>", opts)
set_keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts)
set_keymap("n", "<Esc>", "<cmd>noh<CR>", opts)
set_keymap("n", "Q", "<cmd>Bdelete<CR>", opts)
set_keymap("n", "U", "<C-r>", opts)
set_keymap("n", "Y", "y$", opts)
set_keymap("n", "n", "nzzzv", opts)
set_keymap("n", "N", "Nzzzv", opts)
set_keymap("n", "S", ":%s///<Left><Left>", { silent = false, noremap = true })
set_keymap("n", "µ", "<cmd>Glow<cr>", opts)
set_keymap("n", "Ú", "<C-w>| <C-w>_", opts)
set_keymap("n", "˝", "<C-W>J", opts)
set_keymap("n", "˛", "<C-W>K", opts)
set_keymap("n", "¸", "<C-W>H", opts)
set_keymap("n", "ˇ", "<C-W>L", opts)
set_keymap("n", "Ø", "O<Esc>j", opts)
set_keymap("n", "ø", "o<Esc>k", opts)
-- move text
set_keymap("n", "º", "<Esc>:m .-2<CR>==", opts)
set_keymap("n", "ª", "<Esc>:m .+1<CR>==", opts)

-- del.setete & cut
set_keymap("n", "x", [["_x]], opts)
set_keymap("n", "d", [["_d]], opts)
set_keymap("n", "D", [["_D]], opts)

-- VIS.setUAL MODE
set_keymap("v", "<M-Left>", "b", opts)
set_keymap("v", "<M-Right>", "w", opts)
set_keymap("v", "<BS>", [["_d]], opts)
set_keymap("v", "d", [["_d]], opts)
set_keymap("v", "<", "<gv", opts)
set_keymap("v", ">", ">gv", opts)
set_keymap("v", "p", "_dP", opts)

-- mov.sete selected text
set_keymap("x", "J", [[:move '>+1<CR>gv-gv]], opts)
set_keymap("x", "K", [[:move '<-2<CR>gv-gv]], opts)
set_keymap("x", "ª", [[:move '>+1<CR>gv-gv]], opts) -- <A-j>
set_keymap("x", "º", [[:move '<-2<CR>gv-gv]], opts) -- <A-k>
