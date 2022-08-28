-------------------------------------
-- File         : autopairs.lua
-- Description  : Lua K NeoVim & VimR autopairs config
-- Author       : Kevin
-- Last Modified: 27 Aug 2022, 09:44
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
  break_undo = true,
  map_c_w = true,
  map_c_h = false,
  enable_check_bracket_line = true,
	disable_filetype = { "TelescopePrompt", "Alpha", },
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
