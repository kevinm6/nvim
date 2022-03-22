-------------------------------------
-- File: autopairs.lua
-- Description: Lua K NeoVim & VimR autopairs config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/autopairs.lua
-- Last Modified: 22/03/2022 - 17:13
-------------------------------------

local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then return end

npairs.setup {
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = true,
	},
  enable_check_bracket_line = true,
	disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<C-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}

