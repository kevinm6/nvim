-----------------------------------
--	File         : impatient.lua
--	Description  : impatient config
--	Author       : Kevin
--	Last Modified: 12 Jun 2022, 13:31
-----------------------------------

local ok, impatient = pcall(require, "impatient")
if not ok then return end

impatient.enable_profile()
