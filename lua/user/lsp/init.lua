-------------------------------------
-- File: init.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 21/12/21 - 19:49
-------------------------------------



local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.lsp.lsp-signature"
require "user.lsp.lsp-installer"
require("user.lsp.handlers").setup()
