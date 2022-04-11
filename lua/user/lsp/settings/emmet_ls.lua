-------------------------------------
-- File         : emmet_ls.lua
-- Description  : emmet_ls server config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/emmet_ls.lua
-- Last Modified: 19/02/2022 - 13:48
-------------------------------------

return {
	cmd = { "ls_emmet", "--stdio" },
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


