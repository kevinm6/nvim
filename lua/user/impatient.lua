-----------------------------------
--	File: impatient.lua
--	Description: impatient config
--	Author: Kevin
--	Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/impatient.lua
--	Last Modified: 23/02/2022 - 09:26
-----------------------------------

local status_ok, impatient = pcall(require, "impatient")
if not status_ok then return end

impatient.enable_profile()
