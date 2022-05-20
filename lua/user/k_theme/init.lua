-------------------------------------
-- File         : init.lua
-- Description  : k_theme lua init config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/k_theme/init.lua
-- Last Modified: 20/04/2022 - 09:30
-------------------------------------

local base = require "user.k_theme.base"
local plugins = require "user.k_theme.plugins"
local langs = require "user.k_theme.languages"
local utils = require "user.k_theme.utils"

local specs = { base, plugins, langs }
local spec = utils.merge(specs)

local M = {}

function M.load()
	if vim.version().minor < 7 then
		vim.notify(
      "Neovim 0.7+ required < k_theme >",
      "Error",
      { title = "K_theme colorscheme" }
    )
		return
	end

	vim.api.nvim_command "hi clear"
	if vim.fn.exists "syntax_on" then
		vim.api.nvim_command "syntax reset"
	end

	-- Main Option
	vim.g.colors_name = "k_theme"
	vim.opt.termguicolors = true

  utils.set_highlights(spec)
end

return M
