-------------------------------------
-- File         : ltex.lua
-- Description  : ltex server config
-- Author       : Kevin
-- Last Modified: 25/02/2022 - 11:22
-------------------------------------

return {
  settings = {
    ltex = {
      language = "en",
      completionEnabled = false,
      dictionary = {
        ["en"] = {":/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/en.utf-8.add"},
        ["it"] = {":/Users/Kevin/.MacDotfiles/nvim/.config/nvim/spell/it.utf-8.add"},
      },
      additionalRules = {
        motherTongue = "it",
      },
      java = {
        path = "/usr/local/opt/openjdk/bin",
      },
    },
  }
}
