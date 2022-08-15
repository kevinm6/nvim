-------------------------------------
--  File         : functions.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 12 Aug 2022, 09:50
-------------------------------------

local M = {}

vim.cmd [[
  function Test()
    %SnipRun
    call feedkeys("\<esc>`.")
  endfunction

  function TestI()
    let b:caret = winsaveview()    
    %SnipRun
    call winrestview(b:caret)
  endfunction
]]

function M.sniprun_enable()
  vim.cmd [[
    %SnipRun

    augroup _sniprun
     autocmd!
     autocmd TextChanged * call Test()
     autocmd TextChangedI * call TestI()
    augroup end
  ]]
  vim.notify "Enabled SnipRun"
end

function M.disable_sniprun()
  M.remove_augroup "_sniprun"
  vim.cmd [[
    SnipClose
    SnipTerminate
    ]]
  vim.notify "Disabled SnipRun"
end

function M.toggle_sniprun()
  if vim.fn.exists "#_sniprun#TextChanged" == 0 then
    M.sniprun_enable()
  else
    M.disable_sniprun()
  end
end

function M.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

vim.api.nvim_buf_create_user_command(0, "SnipRunToggle",
  require("user.functions").toggle_sniprun(),
  { force = true, desc = "Toggle SnipRun plugin" }
)

-- get length of current word
function M.get_word_length()
  local word = vim.fn.expand "<cword>"
  return #word
end

function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_tabline()
  local value = vim.api.nvim_get_option_value("showtabline", {})

  if value == 2 then
    value = 0
  else
    value = 2
  end

  vim.opt.showtabline = value

  vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

-----------------------------------------------------

-- Autosource/autoreload modified modules
local source = { re = [[\v%(^|/)%(lua/)\zs.{-}\ze%(/init)?\.lua$]] }
local user = {}

-- For use with SourceCmd autocmd event
function M.source.reload_module(filename)
  local relative = vim.fn.matchstr(filename, [[\v%(^|/)%(lua/)\zs.{-}%(/init)?\.lua$]])
  local module = vim.fn.matchstr(relative, [[\v.{-}\ze%(/init)?\.lua$]])
  local parent = vim.split(module, '/')[1]
  module = module:gsub('/', '.')
  if module == '' then
    dofile(filename)
    -- vim.notify(string.format('Reloaded %s', filename))
    return
  end

  if parent == 'user' then
    -- package.loaded[module]
    package.loaded[module] = dofile(filename)
    vim.notify(string.format('Reloaded %s', relative))
    return
  end

  user.last_reloaded = source.unload(parent)
  table.sort(user.last_reloaded)

  package.loaded[module] = dofile(filename) or true
  for _, name in ipairs(user.last_reloaded) do
    if name ~= module then
      require(name)
    end
  end

  vim.notify(string.format('Reloaded %s and all "%s" submodules', relative, parent))
end

function M.source.unload(name)
  local _re = '^' .. name
  user.last_reloaded = {}
  local unloaded = {}
  for submod, _ in pairs(package.loaded) do
    if submod:match(_re) then
      package.loaded[submod] = nil
      unloaded[#unloaded+1] = submod
    end
  end
  return unloaded
end

return M
