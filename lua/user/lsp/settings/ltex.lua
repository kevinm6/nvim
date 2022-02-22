-------------------------------------
-- File: ltex.lua
-- Description: ltex server config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/ltex.lua
-- Last Modified: 14/02/2022 - 13:18
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
			-- dictionary = {
			-- 	"en-US:[:$NVIMDOTDIR/spell/en-US.utf-8.add]",
			-- 	"it-IT:[:$NVIMDOTDIR/spell/it-IT.utf-8.add]"
			-- },
    },
  },
}

