-------------------------------------
-- File: maps.lua
-- Description: Keymaps for NeoVim & VimR
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/maps.lua
-- Last Modified: 13/01/22 - 15:27
-------------------------------------


-- Section: Function to make easy mapping in Lua
	local opts = { noremap = true, silent = true }
	local term_opts = { silent = true }
	local keymap = vim.api.nvim_set_keymap
  -- keymap("", ",", "<Nop>", opts)
	vim.g.mapleader = ","
	vim.g.maplocalleader = ","
-- }


-- Section: Special keys and commands {
  if vim.fn.has('gui_vimr') == 1 then -- VimR keymaps (command key and others)
			-- Normal-mode
			keymap('n', '<D-Right>', '$', opts)
			keymap('n', '<D-Left>', '0', opts)
			keymap('n', '<D-down>', 'G', opts)
			keymap('n', '<D-up>', 'gg', opts)
			keymap('n', '<C-Tab>', 'gt', opts)
			keymap('n', '<C-S-Tab>', 'gT', opts)
			-- Insert-mode
			keymap('i', '<D-Right>', '$', opts)
			keymap('i', '<D-Left>', '0', opts)
			keymap('i', '<D-down>', 'G', opts)
			keymap('i', '<D-up>', 'gg', opts)
			keymap('i', '<D-BS>', '<C-u>', opts)
			keymap('i', '<D-Del>', '<C-o>"_d$', opts)
			keymap('i', '<D-Right>', '<Esc>A', opts)
			keymap('i', '<D-Left>', '<Esc>I', opts)
			keymap('i', '<D-Right>', '<C-o>$', opts)
			keymap('i', '<D-Left>', '<C-o>0', opts)
			keymap('i', '<D-down>', '<C-o>G', opts)
			keymap('i', '<D-up>', '<C-o>gg', opts)
			keymap('i', '<M-BS>', '<C-w>', opts)
			keymap('i', '<M-Del>', '<C-o>"_dw', opts)
			-- Visual-mode
			keymap('v', '<D-Right>', '$', opts)
			keymap('v', '<D-Left>', '0', opts)
			keymap('v', '<D-down>', 'G', opts)
			keymap('v', '<D-up>', 'gg', opts)
  end
-- }


-- Section: Terminal Mode {
		keymap('t', '<Leader>t', ':sb<bar>term<cr><C-W>J:resize12<cr>', term_opts)
		keymap('t', '<Esc>', '<C-\\><C-n>', term_opts)
-- }


-- Section: Insert Mode {
	keymap('i', '<Esc>', '<Esc>`^', opts)
	keymap('i', '<M-Left>', '<C-o>b', opts)
	keymap('i', '<M-Right>', '<C-o>w', opts)
	keymap('i', 'jk', '<Esc>', opts)
	keymap('i', 'kj', '<Esc>', opts)
	keymap('i', ',', ',<C-g>u', opts)
	keymap('i', '.', '.<C-g>u', opts)
	keymap('i', '<S-Right>', '<C-o>vl', opts)
	keymap('i', '<S-Left>', '<C-o>vh', opts)
	keymap('i', '<S-down>', '<C-o>vj', opts)
	keymap('i', '<S-up>', '<C-o>vk', opts)
	keymap('i', '<S-Tab>', '<C-d>', opts)
	keymap('i', '<F2>', '<C-R>=strftime("%d/%m/%y - %H:%M")<CR>', opts)
-- }

-- Section: Normal Mode {
  keymap("n", "<C-h>", "<C-w>h", opts)
  keymap("n", "<C-j>", "<C-w>j", opts)
  keymap("n", "<C-k>", "<C-w>k", opts)
	keymap('n', '<C-l>', '<Nop>', opts)
  keymap("n", "<C-l>", "<C-w>l", opts)
  keymap("n", "<C-r>", "<cmd>redraw!<CR>", opts)
	keymap('n', '<esc><esc>', '<cmd>nohlsearch<CR>', opts)
	keymap("n", "<S-l>", ":bnext<CR>", opts)
	keymap("n", "<S-h>", ":bprevious<CR>", opts)
	keymap('n', '<M-Left>', 'b', opts)
	keymap('n', '<M-Right>', 'w', opts)
	keymap('n', 'U', '<C-r>', opts)
	keymap('n', 'Y', 'y$', opts)
	keymap('n', 'n', 'nzzzv', opts)
	keymap('n', 'N', 'Nzzzv', opts)
	keymap('n', '<S-Left>', 'vh', opts)
	keymap('n', '<S-Right>', 'vl', opts)
	keymap('n', '<S-up>', 'vk', opts)
	keymap('n', '<S-down>', 'vj', opts)
	keymap('n', 'S', ':%s///<Left><Left>', { silent = false, noremap = true })
	keymap('n', 'µ', ':Glow<CR>', opts)
	keymap('n', 'Ú', '<C-w>| <C-w>_', opts)
	keymap('n', '˝', '<C-W>J', opts)
	keymap('n', '˛', '<C-W>K', opts)
	keymap('n', '¸', '<C-W>H', opts)
	keymap('n', 'ˇ', '<C-W>L', opts)
	keymap('n', 'Ø', 'O<Esc>j', opts)
	keymap('n', 'ø', 'o<Esc>k', opts)

	-- delete & cut
	keymap('n', 'x', '"_x', opts)
	keymap('n', 'd', '"_d', opts)
	keymap('n', 'D', '"_D', opts)
-- }


-- Section: Visual Mode {
	keymap('v', '<leader>d', '""d', opts)
	keymap('v', 'd', '"_d', opts)
	keymap('v', '<BS>', '"_d', opts)
	keymap('v', '<M-Left>', 'b', opts)
	keymap('v', '<M-Right>', 'w', opts)
	keymap('v', '<', '<gv', opts)
	keymap('v', '>', '>gv', opts)
	keymap('v', 'p', '_dP', opts)

  -- move selected text
	keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
	keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
	keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
	keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
-- }

