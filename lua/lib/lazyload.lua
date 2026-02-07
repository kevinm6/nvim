-------------------------------------
-- title: lazyload.lua
-- abstract: utilities function to lazy load plugins
-- author: Kevin
-- date: 01 Jan 2026, 18:56
-------------------------------------

local M = {}

local api = vim.api
local keymap = vim.keymap

---Create a keymap stub, to be used as trigger to execute stuff
---@param modes string|string[] mode or modes that triggers the command
---@param lhs string the matching chars to be used as trigger
---@param callback function the function to be executed once command is triggered
---@param opts? vim.keymap.set.Opts options to be passed to keymaps for desc and more
function M.keymap_stub(modes, lhs, callback, opts)
  keymap.set(modes, lhs, function()
    keymap.del(modes, lhs)
    callback()
    api.nvim_input(lhs) -- replay keybind
  end, opts or {})
end

---Create a command stub, useful to be used as skeleton to execute it once has been trigger
---@param cmd string the exact command name
---@param callback function the function to be executed once command is triggered
function M.command_stub(cmd, callback)
  api.nvim_create_user_command(cmd, function()
    api.nvim_del_user_command(cmd) -- remove stub command
    callback()
    vim.cmd(cmd)
  end, {})
end

---Pre declare module that will be loaded after
---@param mod string name of the module
---@param callback function the function to be executed once loaded
function M.require_stub(mod, callback)
  package.preload[mod] = function()
    package.loaded[mod] = nil
    package.preload[mod] = nil
    return callback()
  end
end

return M