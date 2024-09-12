-------------------------------------
--  File         : session.lua
--  Description  : module to manage vim builtin sessions
--  Author       : Kevin
--  Last Modified: 08 Sep 2024, 11:06
-------------------------------------

local session = {
  dir = string.format("%s/session", vim.fn.stdpath "state"),
}

---Get available sessions
---@private
---@return table
local function get_sessions()
  local sessions = {}

  local sessions_files = vim.split(vim.fn.globpath(session.dir, "*.vim"), "\n", { trimempty = true })

  for _, f in pairs(sessions_files) do
    table.insert(sessions, f)
  end
  return sessions
end

---Delete selected session
local function delete_session()
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
            vim.notify(string.format("Session < %s > deleted!", choice_name), vim.log.levels.WARN)
          end,
        })
      end
    end)
  else
    vim.notify("No Sessions to delete", vim.log.levels.WARN)
  end
end

---Restore selected session
local function restore_session()
  local sessions = get_sessions()

  if #sessions >= 1 then
    require "telescope"
    vim.ui.select(sessions, {
      prompt = " > Select session to restore",
      format_item = function(item)
        return string.format("(%s)  %s", item, vim.fn.fnamemodify(item, ":p:t:r"))
      end,
      default = nil,
    }, function(choice)
      local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
      if choice then
        vim.cmd.source(choice)
        require("core.statusline").session_name = s_name
        vim.notify(string.format("Session < %s > restored!", choice), vim.log.levels.INFO)
      end
    end)
  else
    vim.notify("No Sessions to restore", vim.log.levels.WARN)
  end
end

---Save current vim session with name.
--- The session is saved into 'data' stdpath of nvim
---@see mksession |:mksession|
local function save_session()
  require "telescope"
  vim.ui.input({
    prompt = "Enter session name: ",
    default = nil,
  }, function(input)
    if input then
      if vim.fn.isdirectory(session.dir) ~= 1 then
        vim.fn.mkdir(session.dir, "pR")
      end
      local new_session_path = string.format("%s/%s.vim", session.dir, input)
      vim.cmd.mksession { new_session_path, bang = true }
      -- vim.cmd("mksession! " .. mks_path)
      vim.notify(string.format("Session < %s > created!", input), vim.log.levels.INFO)
    end
  end)
end

---Helper function to usercmd completion
function session.usercmd_session_completion()
  local args = { "restore", "save", "delete" }
  return table.concat(args, "\n")
end

function session.select(arg)
  if arg == "save" then
    save_session()
  elseif arg == "restore" then
    restore_session()
  elseif arg == "delete" then
    delete_session()
  else
    vim.notify("Invalid argument.\nUsage -> :Session [save|restore|delete]", vim.log.levels.WARN, { title = "Session" })
  end
end

return session