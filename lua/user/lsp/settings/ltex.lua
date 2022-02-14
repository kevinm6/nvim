-------------------------------------
-- File: ltex.lua
-- Description: ltex server config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/ltex.lua
-- Last Modified: 14/02/2022 - 10:14
-------------------------------------

return {
  settings = {
    ltex = {
      language = {
        "en",
        "en_US",
				"it"
      },
			additionalRules = {
				motherTongue = {
					"en",
					"en-US",
					"en-GB",
					"it"
				},
			},
      completionEnabled = true,
			java = {
				path = "$JAVA_HOME",
			},
    },
  }
}

