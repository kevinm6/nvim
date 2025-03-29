-------------------------------------
--  File         : session.lua
--  Description  : module to manage vim builtin sessions
--  Author       : Kevin
--  Last Modified: 29 Mar 2025, 23:33
-------------------------------------

local M = {
  dir = string.format("%s/session", vim.fn.stdpath "state"),
}

---Get available sessions
---@return table
local function get_sessions()
  return vim.fn.globpath(M.dir, "*.vim", false, true)
end

---Helper function to usercmd completion
function M.get_sessions_completion()
  local res = {}
  for _, s in pairs(get_sessions()) do
    table.insert(res, vim.fn.fnamemodify(s, ":p:t:r"))
  end
  return res
end

---Delete selected session
local function delete_session()
  local sessions = get_sessions()

  if #sessions >= 1 then
    pcall(require, "snacks")
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
    pcall(require, "snacks")
    vim.ui.select(sessions, {
      prompt = " > Select session to restore",
      format_item = function(item)
        return vim.fn.fnamemodify(item, ":p:t:r")
      end,
      default = nil,
    }, function(choice)
      local s_name = vim.fn.fnamemodify(choice or "", ":p:t:r")
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
  pcall(require, "snacks")
  vim.ui.input({
    prompt = "Enter session name: ",
    default = nil,
    completion = "customlist,v:lua.require'lib.session'.get_sessions_completion",
  }, function(input)
    if input then
      local op = "created"
      local session_file_path = string.format("%s/%s.vim", M.dir, input)

      if vim.fn.isdirectory(M.dir) ~= 1 then
        vim.fn.mkdir(M.dir, "pR")
      end
      if vim.fn.filewritable(session_file_path) == 1 then
        op = "updated"
      end
      vim.cmd.mksession { session_file_path, bang = true }
      vim.notify(string.format("Session < %s > %s", input, op), vim.log.levels.INFO)
    end
  end)
end

---Helper function to usercmd completion
function M.usercmd_session_completion()
  local args = { "save", "restore", "delete" }
  return args
end

---Select action for Session
function M.select(arg)
  if arg == "" then
    vim.ui.select(M.usercmd_session_completion(), {
      prompt = "Sessions> choose",
    }, function(choice)
      if choice ~= nil and M[choice] then
        M[choice]()
      end
    end)
  elseif M[arg] then
    M[arg]()
  else
    vim.notify("Invalid argument.\nUsage -> :Session [save|restore|delete]", vim.log.levels.WARN, { title = "Session" })
  end
end

M.save = save_session
M.restore = restore_session
M.delete = delete_session

return M
