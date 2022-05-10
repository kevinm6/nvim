-------------------------------------
-- File         : pyright.lua
-- Description  : Pyright server config
-- Author       : Kevin
-- Last Modified: 13/01/22 - 15:57
-------------------------------------

return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      },
    },
  },
}
