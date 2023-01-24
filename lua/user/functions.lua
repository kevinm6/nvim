-------------------------------------
--  File         : functions.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 24 Jan 2023, 09:39
-------------------------------------

local F = {}

function F.sniprun_enable()
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

function F.disable_sniprun()
  F.remove_augroup "_sniprun"
  vim.cmd [[
    SnipClose
    SnipTerminate
    ]]
  vim.notify "Disabled SnipRun"
end

function F.toggle_sniprun()
  if vim.fn.exists "#_sniprun#TextChanged" == 0 then
    F.sniprun_enable()
  else
    F.disable_sniprun()
  end
end

function F.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

-- vim.api.nvim_buf_create_user_command(0, "SnipRunToggle",
--   require("user.functions").toggle_sniprun(),
--   { force = true, desc = "Toggle SnipRun plugin" }
-- )

-- get length of current word
function F.get_word_length()
  local word = vim.fn.expand "<cword>"
  return #word
end

function F.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

function F.toggle_tabline()
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
function F.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

-----------------------------------------------------

-- -- Autosource/autoreload modified modules
-- local source = { re = [[\v%(^|/)%(lua/)\zs.{-}\ze%(/init)?\.lua$]] }
-- local user = {}

-- -- For use with SourceCmd autocmd event
-- function M.source.reload_module(filename)
--   local relative = vim.fn.matchstr(filename, [[\v%(^|/)%(lua/)\zs.{-}%(/init)?\.lua$]])
--   local module = vim.fn.matchstr(relative, [[\v.{-}\ze%(/init)?\.lua$]])
--   local parent = vim.split(module, '/')[1]
--   module = module:gsub('/', '.')
--   if module == '' then
--     dofile(filename)
--     -- vim.notify(string.format('Reloaded %s', filename))
--     return
--   end

--   if parent == 'user' then
--     -- package.loaded[module]
--     package.loaded[module] = dofile(filename)
--     vim.notify(string.format('Reloaded %s', relative))
--     return
--   end

--   user.last_reloaded = source.unload(parent)
--   table.sort(user.last_reloaded)

--   package.loaded[module] = dofile(filename) or true
--   for _, name in ipairs(user.last_reloaded) do
--     if name ~= module then
--       require(name)
--     end
--   end

--   vim.notify(string.format('Reloaded %s and all "%s" submodules', relative, parent))
-- end

-- function M.source.unload(name)
--   local _re = '^' .. name
--   user.last_reloaded = {}
--   local unloaded = {}
--   for submod, _ in pairs(package.loaded) do
--     if submod:match(_re) then
--       package.loaded[submod] = nil
--       unloaded[#unloaded+1] = submod
--     end
--   end
--   return unloaded
-- end


-- SESSIONS
function F.delete_session()
  local sessions_data_stdpath = vim.fn.stdpath "data".."/sessions/"
  local sessions = vim.list_extend({}, vim.split(vim.fn.globpath(sessions_data_stdpath, "*"), "\n"))
  vim.ui.select(sessions, {
    prompt = "Select session to delete:",
    default = nil,
    -- format_item = function(item) return "" end,
   }, function(choice)
       if choice then
         vim.cmd("! rm ".. choice)
         vim.notify("Session < "..choice.." > deleted!", "Warn")
       end
   end)
end


function F.restore_session()
  local sessions_data_stdpath = vim.fn.stdpath "data".."/sessions/"
  local sessions = vim.list_extend({}, vim.split(vim.fn.globpath(sessions_data_stdpath, "*"), "\n"))
  if #sessions > 0 then
    vim.ui.select(sessions, {
      prompt = " > Select session to restore",
      default = nil,
      -- format_item = function(item) return "" end,
     }, function(choice)
          local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
          if choice then
            vim.cmd.source(choice)
            require "core.statusline".session_name = s_name
            vim.notify("Session < "..choice.." > restored!", "Info")
         end
     end)
  else
    vim.notify("No Sessions to restore", "Warn")
  end
end

function F.save_session()
  vim.ui.input({
    prompt = "Enter session name: ",
    default = nil,
    -- completion = "-complete=buffer,dir"
   }, function(input)
       if input then
         local mks_path = vim.fn.stdpath "data".."/sessions/"..input..".vim"
         vim.cmd("mksession! "..mks_path)
         vim.notify("Session < "..input.." > created!", "Info")
       end
   end)
end

-- END SESSIONS

function F.align(pat)
    local top, bot = vim.fn.getpos("'<"), vim.fn.getpos("'>")
    F.align_lines(pat, top[2] - 1, bot[2])
    vim.fn.setpos("'<", top)
    vim.fn.setpos("'>", bot)
end

function F.align_lines(pat, startline, endline)
    local re = vim.regex(pat)
    local max = -1
    local lines = vim.api.nvim_buf_get_lines(0, startline, endline, false)
    for _, line in pairs(lines) do
        local s = re:match_str(line)
        s = vim.str_utfindex(line, s)
        if s and max < s then
            max = s
        end
    end

    if max == -1 then return end

    for i, line in pairs(lines) do
        local s = re:match_str(line)
        s = vim.str_utfindex(line, s)
        if s then
            local rep = max - s
            local newline = {
                string.sub(line, 1, s),
                string.rep(' ', rep),
                string.sub(line, s + 1),
            }
            lines[i] = table.concat(newline)
        end
    end

    vim.api.nvim_buf_set_lines(0, startline, endline, false, lines)
end

function F.range_format()
  local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
      local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
      vim.lsp.buf.format({
          range = {
              ["start"] = { start_row, 0 },
              ["end"] = { end_row, 0 },
          },
          async = true,
      })
end


-- Format on save
function F.format_on_save(enable)
  local action = function() return enable and "Enabled" or "Disabled" end

  if enable then
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
      pattern = "*",
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  else
    vim.api.nvim_clear_autocmds { group = "format_on_save" }
  end

  vim.notify(action().. " format on save", "Info", { title = "LSP" })
end

function F.toggle_format_on_save()
  if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
    F.format_on_save(true)
  else
    F.format_on_save()
  end
end


-- Create new file w/ input for filename
-- useful for dashboard and so on
function F.new_file()
  vim.ui.input({
      prompt = "Enter name for newfile: ",
      default = nil,
     }, function (input)
      if input ~= nil then
        vim.cmd.enew()
        vim.cmd.edit(input)
        vim.cmd.write(input)
        vim.cmd.startinsert()
      end
     end
  )
end

function F.workon()
  local config = require('lazy.core.config')
  vim.ui.select(vim.tbl_values(config.plugins), {
    prompt = 'lcd to:',
    format_item = function(plugin)
      return string.format('%s (%s)', plugin.name, plugin.dir)
    end,
  }, function(plugin)
    if not plugin then
      return
    end
    vim.schedule(function()
      vim.cmd.lcd(plugin.dir)
    end)
  end)
end

return F
