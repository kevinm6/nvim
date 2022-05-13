-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 06/05/2022 - 09:12
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
	pattern = { "qf", "help", "man", "git", "lspinfo", "Scratch", "checkhealth", "sqls_output" },
	command = "lua vim.keymap.set('n', 'q', ':close<CR>', { buffer = true, silent = true } )",
})

autocmd({ "TextYankPost" }, {
	group = _general_settings,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 200, on_macro = true })
	end,
})

-- Autocommand for Statusline
local statusLine = augroup("Statusline", {
	clear = true,
})

autocmd({ "BufWinEnter", "BufEnter" }, {
	group = statusLine,
	pattern = "*",
	callback = function()
		vim.wo.statusline = "%!v:lua.require('user.statusline').active()"
	end,
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = statusLine,
	pattern = "alpha",
	callback = function()
		vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('Dashboard')"
	end,
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = statusLine,
	pattern = "NvimTree*",
	callback = function()
		vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('File Explorer')"
	end,
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = statusLine,
	pattern = "packer",
	callback = function()
		vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('Package Manager')"
	end,
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = statusLine,
	pattern = { "lsp-installer", "lsp-info" },
	callback = function()
		vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('Language Server Protocol')"
	end,
})

autocmd({ "FileType", "BufEnter", "WinEnter" }, {
	group = statusLine,
	pattern = "Telescope*",
	callback = function()
		vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('Telescope')"
	end,
})

-- Markdown

autocmd({ "BufNewFile", "BufRead" }, {
	group = augroup("_markdown", { clear = true }),
	pattern = { "*.markdown", "*.mdown", "*.mkd", "*.mkdn", "*.md" },
	callback = function()
		vim.opt_local.filetype = "markdown"
	end,
})

-- Java
autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function()
		vim.lsp.codelens.refresh()
	end,
})

-- SQL

autocmd({ "BufNewFile", "BufRead" }, {
	group = augroup("_sql", { clear = true }),
	pattern = "*.psql*",
	callback = function()
		vim.opt_local.filetype = "sql"
	end,
})

-- illuminate

autocmd({ "VimEnter" }, {
	group = augroup("_illuminate", { clear = false }),
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "illuminatedWord", { link = "LspReferenceText" })
	end,
})

-- auto_resize

autocmd({ "VimResized" }, {
	group = augroup("_auto_resize", { clear = true }),
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
