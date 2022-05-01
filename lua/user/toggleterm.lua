-------------------------------------
-- File         : toggleterm.lua
-- Descriptions : ToggleTerm config
-- Author       : Kevin
-- Last Modified: 12/03/2022 - 17:37
-------------------------------------

local ok, toggleterm = pcall(require, "toggleterm")
if not ok then return end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = "/bin/zsh",
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

local function set_terminal_keymaps()
  local opts = {noremap = true}
  -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    set_terminal_keymaps()
  end,
})

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true })
function _HTOP_TOGGLE()
	htop:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
function _NCDU_TOGGLE()
	ncdu:toggle()
end
