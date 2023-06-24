-------------------------------------
--  File         : sessions.lua
--  Description  : module to manage vim builtin sessions
--  Author       : Kevin
--  Last Modified: 24 Jun 2023, 10:48
-------------------------------------

local S = {}

--- Get available sessions
--- @private
--- @return table
local get_sessions = function()
   local sessions = {}

   local sessions_data_stdpath = vim.fn.stdpath "data" .. "/sessions"
   local sessions_files = vim.split(
      vim.fn.globpath(sessions_data_stdpath, "*.vim"),
      "\n",
      { trimempty = true }
   )

   for _, f in pairs(sessions_files) do
      table.insert(sessions, f)
   end
   return sessions
end

--- Delete selected session
S.delete_session = function()
   local sessions = get_sessions()

   if #sessions >= 1 then
      require "telescope"
      vim.ui.select(sessions, {
         prompt = "Select session to delete:",
         default = nil,
      }, function(choice)
         if choice then
            vim.fn.jobstart("mv " .. vim.fn.fnameescape(choice) .. " ~/.Trash", {
               detach = true,
               on_exit = function()
                  local choice_name = vim.fn.fnamemodify(choice, ":t")
                  vim.notify(
                     ("Session < %s > deleted!"):format(choice_name),
                     vim.log.levels.WARN
                  )
               end,
            })
         end
      end)
   else
      vim.notify("No Sessions to delete", vim.log.levels.WARN)
   end
end

--- Restore selected session
S.restore_session = function()
   local sessions = get_sessions()

   if #sessions >= 1 then
      require "telescope"
      vim.ui.select(sessions, {
         prompt = " > Select session to restore",
         default = nil,
      }, function(choice)
         local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
         if choice then
            vim.cmd.source(choice)
            require("core.statusline").session_name = s_name
            vim.notify(("Session < %s > restored!"):format(choice), vim.log.levels.INFO)
         end
      end)
   else
      vim.notify("No Sessions to restore", vim.log.levels.WARN)
   end
end


--- Save current vim session with name.
---   The session is saved into 'data' stdpath of nvim
--- @see |:mksession|
S.save_session = function()
   require "telescope"
   vim.ui.input({
      prompt = "Enter session name: ",
      default = nil,
   }, function(input)
      if input then
         local mks_path = vim.fn.stdpath "data" .. "/sessions/" .. input .. ".vim"
         vim.cmd("mksession! " .. mks_path)
         vim.notify(("Session < %s > created!"):format(input), vim.log.levels.INFO)
      end
   end)
end

return S
