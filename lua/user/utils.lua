-----------------------------------
--	File: utils.lua
--	Description: utilities functions, icons and so on
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/utils.lua
--	Last Modified: 11/03/2022 - 16:02
-----------------------------------


local notify = require "user.notify"

local U = {}

-- LoadModule safe or notify an Error
function U.loadModule(moduleName)
	local status_ok, mod = pcall(require, moduleName)
	if not status_ok then
		notify(U.icons.diagnostics.Error .. " Error loading  " .. "  " .. moduleName, "Hint")
		return mod
	end
	return mod
end

return U
