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
  callback = function()
    vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 200, on_macro = true })
  end,
})

-- Autocommand for Statusline
local statusLine = augroup("Statusline", {
  clear = true,
})

-- vim.wo.statusline = "%!v:lua.Disabled('Dashboard')"
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
    vim.wo.statusline = "%!v:lua.require'user.statusline'.disabled('LSP')"
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
  pattern = "*.psql*",
  callback = function()
    vim.opt_local.filetype = "sql"
  end,
})

-- illuminate
local _illuminate = augroup("_illuminate", {
  clear = false,
})

autocmd({ "VimEnter" }, {
  group = _illuminate,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "illuminatedWord", { link = "LspReferenceText" })
  end,
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
