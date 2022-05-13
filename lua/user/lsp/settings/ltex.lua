-------------------------------------
-- File         : ltex.lua
-- Description  : ltex-ls server config
-- Author       : Kevin
-- Last Modified: 13/05/2022 - 09:51
-------------------------------------

local ltex_root_path = vim.fn.stdpath "data".."/ltex"
local ltex_binary = ltex_root_path.."/ltex-ls/bin"

return {
  cmd = { ltex_binary },
	autostart = false,
	language = "en",
	completionEnabled = false,
	dictionary = {
		["en"] = { ":/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add" },
		["it"] = { ":/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/it.utf-8.add" },
	},
	additionalRules = {
		motherTongue = "it",
	},
	java = {
		path = "/usr/local/opt/openjdk/bin",
	},
}
