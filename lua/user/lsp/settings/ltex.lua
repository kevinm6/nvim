-------------------------------------
-- File: ltex.lua
-- Description: ltex server config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/ltex.lua
-- Last Modified: 23/02/2022 - 11:48
-------------------------------------

return {
  settings = {
    ltex = {
      language = {
				"it",
        "en-US",
				"en-GB"
     },
			additionalRules = {
				motherTongue = {
					"it",
					"en-US",
					"en-GB",
				},
			},
      completionEnabled = true,
			java = {
				path = "$JAVA_HOME",
			},
			dictionary = {
				["en-US"] = { ":~/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.txt" },
				["it-IT"] = { ":~/.MacDotfiles/nvim/.config/nvim/spell/it.utf-8.txt" },
			},
    },
  },
}

