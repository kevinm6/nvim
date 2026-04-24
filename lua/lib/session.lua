-------------------------------------
-- title: session.lua
-- abstract: module to manage vim builtin sessions
-- author: Kevin
-- date: 24 Apr 2026, 12:16
-------------------------------------

local M = {
  dir = vim.fn.stdpath "state" .. "/session",
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
          vim.api.nvim_echo({ { "Session: ", "OkMsg" }, { choice_name, "MatchParen" }, { " deleted", "WarningMsg" } },
            true, {})
        end
      end
    end)
  else
    vim.api.nvim_echo({ { "Session: ", "OkMsg" }, { "no sessions to delete", "ErrorMsg" } }, true, {})
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
      if choice then
        local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
        vim.cmd.source(choice)
        require("lib.ui.statusline").session_name = s_name
        vim.api.nvim_echo({ { "Session: ", "OkMsg" }, { s_name, "MatchParen" }, { " restored", "OkMsg" } }, true, {})
      end
    end)
  else
    vim.api.nvim_echo({ { "Session: ", "OkMsg" }, { "no sessions to restore", "ErrorMsg" } }, true, {})
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
    if input == nil then
      return
    end
    input = vim.trim(input)
    if input ~= "" then
      local op = "created"
      local session_file_path = M.dir .. "/" .. input .. ".vim"
      local res, err = nil, nil
      if vim.fn.isdirectory(M.dir) ~= 1 then
        _, err = vim.schedule(function()
          vim.fn.mkdir(M.dir, "p")
        end):wait()
      end
      if vim.fn.filewritable(session_file_path) == 1 then
        op = "updated"
      end
        if not err then
          vim.cmd.mksession { session_file_path, bang = true }
          vim.api.nvim_echo({ { "\nSession: ", "OkMsg" }, { " session ", "StdoutMsg" }, { input, "Type" }, { " " .. op, "Function" } }, true, {})
        else
          vim.api.nvim_echo({ { "\nSession: ", "OkMsg" }, { "failed to create session ", "ErrorMsg" }, { input, "Type" } , { "\n" .. err, "ErrorMsg" } }, true, {})
        end
    else
      print "  canceled"
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
    vim.api.nvim_echo({ { "Session: invalid argument", "WarningMsg" }, { "Usage -> :Session [save|restore|delete]" } },
      true, {})
  end
end

M.save = save_session
M.restore = restore_session
M.delete = delete_session

return M