-------------------------------------
-- File         : init.lua
-- Description  : knvim lua init config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/k_theme/init.lua
-- Last Modified: 11 Aug 2022, 10:35
-------------------------------------

local base = require "colors.knvim.base"
local plugins = require "colors.knvim.plugins"
local langs = require "colors.knvim.languages"
local utils = require "colors.knvim.utils"

local specs = { base, plugins, langs }
local spec = utils.merge(specs)

local M = {}

function M.load()
	if vim.version().minor < 7 then
		vim.notify(
      "Neovim 0.7+ required for < knvim > theme",
      "Error",
      { title = "knvim colorscheme" }
    )
		return
	end

  -- resetting colors
	vim.cmd "hi clear"
	if vim.fn.exists "syntax_on" then
		vim.cmd "syntax reset"
	end

	-- Main Option
	vim.g.colors_name = "knvim"
	vim.opt.termguicolors = true

  utils.set_highlights(spec)
end

return M
