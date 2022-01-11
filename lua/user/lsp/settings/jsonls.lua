-------------------------------------
-- File: jsonls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/jsonls.lua
-- Last Modified: 11/01/22 - 15:22
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
