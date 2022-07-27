-------------------------------------
-- File         : init.lua
-- Description  : k_theme lua init config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/k_theme/init.lua
-- Last Modified: 26 Jul 2022, 13:27
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
	vim.g.colors_name = "knvim"
	vim.opt.termguicolors = true

  utils.set_highlights(spec)
end

return M
