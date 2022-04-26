-----------------------------------
--  File         : hop.lua
--  Description  : hop plugin configuration
--  Author       : Kevin
--  Last Modified: 23/03/2022 - 17:01
-----------------------------------


local ok, hop = pcall(require, "hop")
if not ok then return end

hop.setup()

vim.api.nvim_set_keymap("", "\\", "<cmd>HopWord<cr>", { silent = true })
