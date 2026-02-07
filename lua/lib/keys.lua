-------------------------------------
-- title: keys.lua
-- abstract: Keymaps utilities for NeoVim
-- author: Kevin
-- date: 25/04/2025, 09:19
-------------------------------------

local M = {}

--- NOTE:if they deliver this -> https://github.com/neovim/neovim/issues/28536
--- at least at the begin just switch the indexes (3, 4) in mapping function wrapper

---Helper function
---@param tbl table table that contains all the params to be passed to `vim.keymap.set`
---  1. mode
---  2. keys
---  3. command|function
---  4. opts
local function map(tbl)
  vim.keymap.set(tbl[1], tbl[2], tbl[3], tbl[4])
end

function M.nmap(tbl)
  map { "n", tbl[1], tbl[2], { desc = tbl[3] } }
end

function M.vmap(tbl)
  map { "v", tbl[1], tbl[2], { desc = tbl[3] } }
end

function M.tmap(tbl)
  map { "t", tbl[1], tbl[2], { desc = tbl[3] } }
end

function M.imap(tbl)
  map { "i", tbl[1], tbl[2], { desc = tbl[3] } }
end

M.map = map

return M