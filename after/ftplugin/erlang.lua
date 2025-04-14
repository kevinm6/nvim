-------------------------------------
-- File         : erlang.lua
-- Description  : filetype erlang configuration
-- Author       : Kevin
-- Last Modified: 17 Apr 2025, 19:02
-------------------------------------

vim.opt_local.makeprg = "erlc -Wall"
vim.opt_local.errorformat = "%f:%l:%c: %m"