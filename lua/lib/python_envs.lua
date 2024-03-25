-------------------------------------
--  File         : python_envs.lua
--  Description  : helper module to get and manage python_envs
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 13:34
-------------------------------------

---Python envs
--- Available funcs:
---   - get_current_venv
---   - pick_venv
local pyvenv = {}

---Set Python venv
---@private
---@param venv table set this venv as current python venv
function pyvenv.set_venv(venv)
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
function pyvenv.get_current_venv()
  return vim.g.python_venv
end

---Get Python venvs from given paths
---@private
---@param venvs_path table list of paths of python venvs
---@return table
local function get_venvs(venvs_path)
  local paths = venvs_path
  local venvs = {}
  for _, path in ipairs(paths) do
    table.insert(venvs, {
      name = vim.fn.fnamemodify(path, ":~"),
      path = path,
    })
  end
  return venvs
end

---Show a picker for select Python venv
---and make it active
function pyvenv.pick_venv()
  local venvs_paths = {
    vim.fn.expand "~/dev/audioToText-bot",
    vim.fn.stdpath "data" .. "/nvim_python_venv",
  }

  local venvs = get_venvs(venvs_paths)
  if not next(get_venvs(venvs_paths)) then
    vim.notify("Warning: no virtual_envs found.",
      vim.log.levels.WARN,
      { title = "Py-venvs" })
    return
  end
  vim.ui.select(venvs, {
    prompt = "Select Python venv",
    format_item = function(item)
      local name = vim.fn.fnamemodify(item.name, ":t")
      return ("%s (%s)"):format(name, item.path)
    end,
  }, function(choice)
    if not choice then
      return
    end
    pyvenv.set_venv(choice)
  end)
end

return pyvenv