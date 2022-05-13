-------------------------------------
-- File         : emmet_ls.lua
-- Description  : emmet_ls server config
-- Author       : Kevin
-- Last Modified: 13/05/2022 - 10:07
-------------------------------------

local emmet_root_path = vim.fn.stdpath "data".."/lsp_servers/emmet_ls"
local emmet_binary = emmet_root_path.."/node_modules/.bin/emmet-ls"

return {
	cmd = { emmet_binary, "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "haml",
    "xml",
    "xsl",
    "pug",
    "slim",
    "sass",
    "stylus",
    "less",
    "sss",
    "hbs",
    "handlebars",
  },
}
