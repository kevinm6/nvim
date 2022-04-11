-------------------------------------
-- File         : jsonls.lua
-- Description  : Jsonls server config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/jsonls.lua
-- Last Modified: 31/03/2022 - 14:03
-------------------------------------

local ok, schema = pcall(require, "schemastore")
if not ok then return end



return {
 settings = {
    json = {
      schemas = schema.json.schemas(),
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
