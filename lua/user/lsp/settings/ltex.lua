-------------------------------------
-- File         : ltex.lua
-- Description  : ltex server config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/ltex.lua
-- Last Modified: 25/02/2022 - 11:22
-------------------------------------

return {
  settings = {
    ltex = {
      language = "en",
      completionEnabled = false,
      dictionary = {
        ["en"] = {":/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"},
      },
      additionalRules = {
        motherTongue = "it",
      },
      java = {
        path = "$JAVA_HOME",
      },
    },
  }
}

