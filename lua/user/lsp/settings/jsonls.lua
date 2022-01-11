-------------------------------------
-- File: jsonls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 10/01/22 - 12:29
-------------------------------------

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

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
