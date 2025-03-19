-------------------------------------
--  File         : session.lua
--  Description  : module to manage vim builtin sessions
--  Author       : Kevin
--  Last Modified: 08 Sep 2024, 11:06
-------------------------------------

local M = {
  dir = string.format("%s/session", vim.fn.stdpath "state"),
}

---Get available sessions
---@return table
local function get_sessions()
  local sessions = {}

  local sessions_files = vim.split(vim.fn.globpath(M.dir, "*.vim"), "\n", { trimempty = true })

  for _, f in pairs(sessions_files) do
    table.insert(sessions, f)
  end
  return sessions
end

---Delete selected session
local function delete_session()
  local sessions = get_sessions()

  if #sessions >= 1 then
    pcall(require, "telescope")
    vim.ui.select(sessions, {
      prompt = "Select session to delete:",
      default = nil,
      format_item = function(item)
        return vim.fn.fnamemodify(item, ":p:t:r")
      end,
    }, function(choice)
      if choice then
        local deleted = vim.fn.delete(choice)
        if deleted == 0 then
          local choice_name = vim.fn.fnamemodify(choice, ":t")
          vim.notify(string.format("Session < %s > deleted!", choice_name), vim.log.levels.WARN)
        end
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
    pcall(require, "telescope")
    vim.ui.select(sessions, {
      prompt = " > Select session to restore",
      format_item = function(item)
        return vim.fn.fnamemodify(item, ":p:t:r")
      end,
      default = nil,
    }, function(choice)
      local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
      if choice then
        vim.cmd.source(choice)
        require("lib.ui.statusline").session_name = s_name
        vim.notify(string.format("Session < %s > restored!", s_name), vim.log.levels.INFO)
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
  pcall(require, "telescope")
  vim.ui.input({
    prompt = "Enter session name: ",
    default = nil,
  }, function(input)
    if input then
      if vim.fn.isdirectory(M.dir) ~= 1 then
        vim.fn.mkdir(M.dir, "pR")
      end
      local new_session_path = string.format("%s/%s.vim", M.dir, input)
      vim.cmd.mksession { new_session_path, bang = true }
      vim.notify(string.format("Session < %s > created!", input), vim.log.levels.INFO)
    end
  end)
end

---Helper function to usercmd completion
function M.usercmd_session_completion()
  local args = { "restore", "save", "delete" }
  return table.concat(args, "\n")
end

function M.select(arg)
  arg = vim.trim(arg)
  if arg == "" then
    vim.ui.select({ "save", "delete", "restore" }, {
      prompt = "Sessions> choose",
    }, function(choice)
      if choice == "save" then
        save_session()
      elseif choice == "delete" then
        delete_session()
      elseif choice == "restore" then
        restore_session()
      end
    end)
  elseif arg == "save" then
    save_session()
  elseif arg == "restore" then
    restore_session()
  elseif arg == "delete" then
    delete_session()
  else
    vim.notify("Invalid argument.\nUsage -> :Session [save|restore|delete]", vim.log.levels.WARN, { title = "Session" })
  end
end

return M
