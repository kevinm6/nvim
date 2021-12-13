-------------------------------------
-- File: autopairs.lua
-- Description: Lua K NeoVim & VimR autopairs config
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/core/autopairs.lua
-- Last Modified: 13/12/21 - 16:00
-------------------------------------

local status_ok, npairs  = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end

npairs.setup({
	check_ts = true,
	ts_config = {}
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
