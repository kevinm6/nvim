-----------------------------------
--	File: impatient.lua
--	Description: impatient config
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/impatient.lua
--	Last Modified: 12/03/2022 - 16:27
-----------------------------------

local ok, impatient = pcall(require, "impatient")
if not ok then return end

impatient.enable_profile()
