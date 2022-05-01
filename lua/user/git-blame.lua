-----------------------------------
-- File         : git-blame.lua
-- Description  : git-blame plugin config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/git-blame.lua
-- Last Modified: 10/04/2022 - 14:19
-----------------------------------

vim.g.gitblame_enabled = 0
vim.g.gitblame_message_template = "<summary> • <date> • <author>"
vim.g.gitblame_highlight_group = "LineNr"
