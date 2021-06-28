-------------------------------------
-- File         : jsonls.lua
-- Description  : Jsonls server config
-- Author       : Kevin
-- Last Modified: 15 Oct 2022, 16:07
-------------------------------------

return {
 settings = {
    json = {
      schemas = require "schemastore".json.schemas() or nil,
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
