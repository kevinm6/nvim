-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/autocommands.lua
-- Last Modified: 19/04/2022 - 20:38
-------------------------------------


local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command


-- General
local _general_settings = augroup("_general_settings", {
  clear = true,
})

autocmd({ "FileType" }, {
  group = _general_settings,
  pattern = { "qf", "help", "man", "git", "lspinfo", "Scratch", "checkhealth" },
  command = "lua vim.keymap.set('n', 'q', ':close<CR>', { buffer = true, silent = true } )",
})

autocmd({ "TextYankPost" }, {
  group = _general_settings,
  pattern = "*",
  command = "silent! lua vim.highlight.on_yank({ higroup = 'TextYankPost', timeout = 200 })",
})

-- Autocommand for Statusline
local aug_sl = augroup("Statusline", {
	clear = true,
})

autocmd({ "BufWinEnter", "BufEnter" }, {
	group = aug_sl,
	pattern = "*",
	-- callback = _G.active,
	command = "set statusline=%!v:lua.active()",
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = aug_sl,
	pattern = "alpha",
	-- callback = _G.dashboard,
	command = "set statusline=%!v:lua.dashboard()",
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = aug_sl,
	pattern = "NvimTree*",
	-- callback = _G.explorer,
	command = "set statusline=%!v:lua.explorer()",
})


-- Markdown
local _markdown = augroup("_markdown", {
  clear = true,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = _markdown,
  pattern = { "*.markdown", "*.mdown", "*.mkd", "*.mkdn", "*.md" },
  command = "lua vim.opt_local.filetype = 'markdown'",
})


-- SQL
local _sql = augroup("_sql", {
  clear = true,
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = _sql,
  pattern = "*.psql*" ,
  command = "lua vim.opt_local.filetype = 'sql'",
})


-- illuminate
local _illuminate = augroup("_illuminate", {
  clear = true,
})

autocmd({ "VimEnter" }, {
  group = _illuminate,
  pattern = "*",
  command = "lua vim.api.nvim_command([[ hi def link illuminatedWord LspReferenceText ]])",
})


-- auto_resize
local _auto_resize = augroup("_auto_resize", {
  clear = true,
})

autocmd({ "VimResized" }, {
  group = _auto_resize,
  pattern = "*",
  command = "tabdo wincmd",
})


-- Scratch
local Scratch = function()
  vim.api.nvim_command("new")
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end

command("Scratch", Scratch, { desc = "Create a Scratch buffer" })


-- Note
local Note = function()
  vim.api.nvim_command("new")
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "hide"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Note"
end

command("Note", Note, { desc = "Create a Note buffer" })

