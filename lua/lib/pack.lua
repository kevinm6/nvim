-------------------------------------
--  File         : pack.lua
--  Description  : lib utils function for native package manager
--  Author       : Kevin
--  Last Modified: 13/11/2025, 08:50
-------------------------------------

local M = {}

---Install or check if a plugin is installed
---@param specs table
function M.ensure_installed(specs)
  vim.pack.add(specs, { load = function() end })
end

---Load plugin on event
---@param event string (:h autocmd-events)
---@return function
local function make_load_on_event(event)
  local gr = vim.api.nvim_create_augroup('LoadOn' .. event, {})
  return function(spec)
    vim.api.nvim_create_autocmd(event, {
      group = gr,
      once = true,
      callback = function() vim.pack.add({ spec.name }) end,
    })
  end
end

---Check install and add (with `:h packadd`) it on event
---@param event string (:h autocmd-events)
---@param specs string[]|vim.pack.Spec[]
function M.add_on_event(event, specs)
  vim.pack.add(specs, { load = make_load_on_event(event) })
end

return M


-- TODO to complete
--[[
local function hooks(ev)
  local name, kind = ev.data.spec.name, ev.data.kind

  -- Run build script after plugin's code has changed
  if name == 'plug-1' and (kind == 'install' or kind == 'update') then
    vim.system({ 'make' }, { cwd = ev.data.path })
  end

  if kind == "update" and name == "go.nvim" then
    -- if you need to install/update all binaries
   require("go.install").update_all_sync()
  end

  -- If action relies on code from the plugin (like user command or
  -- Lua code), make sure to explicitly load it first
  if name == 'plug-2' and kind == 'update' then
    if not ev.data.active then
      vim.cmd.packadd('plug-2')
    end
    vim.cmd('PlugTwoUpdate')
    -- require('plug2').after_update()
  end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
]]