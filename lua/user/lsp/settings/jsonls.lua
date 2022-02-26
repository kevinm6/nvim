-------------------------------------
-- File: jsonls.lua
-- Description: Jsonls server config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/jsonls.lua
-- Last Modified: 13/01/22 - 15:57
-------------------------------------

return {
 settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
  setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  },
}
