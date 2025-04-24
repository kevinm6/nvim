-------------------------------------
--  File         : python_envs.lua
--  Description  : helper module to get and manage python_envs
--  Author       : Kevin
--  Last Modified: 10 Apr 2024, 10:43
-------------------------------------

---Python envs
--- Available funcs:
---   - get_current_venv
---   - pick_venv
local M = {
  preset = {
    {
      name = "audioToText",
      path = vim.fn.expand "~/dev/audioToText-bot/.venv"
    },
    {
      name = "nvim",
      path = vim.fn.stdpath "data" .. "/.venv"
    }
  }
}


---Set Python venv
---@private
---@param venv table set this venv as current python venv
function M.set_venv(venv)
  local origin_path = vim.fn.getenv "PATH"
  local venv_bin_path = venv.path .. "/bin"
  if vim.fn.isdirectory(venv_bin_path) == 1 then
    vim.fn.setenv("PATH", venv_bin_path .. ":" .. origin_path)
    vim.fn.setenv("VIRTUAL_ENV", venv.path)
  else
    vim.notify("ERROR: Given path is not a python venv!", vim.log.levels.ERROR, {
      title = "Python Venv"
    })
  end
end

---Get active Python venv
---@return string|nil _ current active python venv or nothing
function M.get_current_venv()
  return vim.g.python_venv
end

---Get Python venvs from given paths
---@private
---@return table
local function get_venvs()
  return M.preset
end

---Show a picker for select Python venv
---and make it active
function M.pick_venv()
  local venvs = get_venvs()

  if not next(venvs) then
    vim.notify("Warning: no virtual_envs found.",
      vim.log.levels.WARN,
      { title = "Py-venvs" })
    return
  end
  vim.ui.select(venvs, {
    prompt = "Select Python venv",
    format_item = function(item)
      return ("%s (%s)"):format(item.name, vim.fn.fnamemodify(item.path, ':~'))
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.set_venv(choice)
  end)
end

---Helper function to usercmd completion
function M.usercmd_pyenv_completion()
  local venvs = {}
  for _, v in pairs(get_venvs()) do
    table.insert(venvs, v.name)
  end
  return table.concat(venvs, "\n")
end

return M