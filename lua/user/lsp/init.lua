-------------------------------------
-- File: init.lua
-- Description: config all module to be imported
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/init.lua
-- Last Modified: 12/03/2022 - 18:25
-------------------------------------


local ok, _ = pcall(require, "lspconfig")
if not ok then return end

require "user.lsp.lsp-signature"
require "user.lsp.lsp-installer"
require("user.lsp.handlers").setup()
