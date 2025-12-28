-------------------------------------
--  File         : python_envs.lua
--  Description  : helper module to get and manage python_envs
--  Author       : Kevin
--  Last Modified: 28 Dec 2025, 17:05
-------------------------------------

---Python envs
--- Available funcs:
---   - get_current_venv
---   - pick_venv
local M = {
  venvs = {
    {
      name = "audioToText",
      path = vim.fn.expand "~/dev/audioToText-bot/.venv"
    },
    {
      name = "nvim",
      path = vim.fn.stdpath "data" .. "/.venv"
    }
  },
}

---Get venv from current table
---@param venv_name string name to be matched
---@return table|nil the value of the venv, nil if not found
local function get_venv(venv_name)
  for _, entry in pairs(M.venvs) do
    if entry.name == venv_name then
      return entry
    end
  end
  return nil
end

---Set Python venv
---@private
---@param venv string|table set this venv as current python venv
function M.set_venv(venv)
  assert(venv, "Venv not passed, expecting string or table")

  local origin_path = vim.fn.getenv "PATH"
  if type(venv) == "string" then
    venv = get_venv(venv) or {}
  else
  end
  local venv_bin_path = venv.path .. "/bin"
  local venv_python = venv_bin_path .. "/python"

  if vim.fn.isdirectory(venv_bin_path) == 1 then
    assert(vim.fn.executable(venv_python) ~= 0, "Python-venvs - Python 'venv' module not available: " .. venv_python)

    vim.fn.setenv("PATH", venv_bin_path .. ":" .. origin_path)
    vim.fn.setenv("VIRTUAL_ENV", venv.path)

    vim.notify("Python-venvs - Virtual environment => " .. venv.path)
    -- Restart the LSP server
    vim.defer_fn(function()
      vim.notify("Python-venvs - Restarting LSP client... ")
      local client = vim.lsp.get_clients { bufnr = vim.api.nvim_get_current_buf(), name = "pyright" }
      if next(client) then
        client[1]:stop()
      else
        return
      end
      vim.lsp.start(vim.lsp.config.pyright)
      vim.cmd.edit()
      vim.notify("Python-venvs - Restarted successfully")
    end, 1000)
  else
    vim.notify("Python-venvs - given path is not a python venv => " .. venv_bin_path, vim.log.levels.WARN)
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
  local current_buf_venv = vim.fs.find({ ".venv", "venv", "virtualenv" },
    {
      limit = 1,
      type = "directory",
      path = vim.fs.root(vim.api.nvim_buf_get_name(0),
        { "pyproject.toml", "setup.py", "main.py" })
    })

  local venv = get_venv("current_dir")
  if not venv then
    table.insert(M.venvs, {
      name = "current_dir",
      path = current_buf_venv[1]
    })
  end

  return M.venvs
end

---Show a picker for select Python venv and make it active
function M.pick_venv()
  local venvs = get_venvs()

  if not next(venvs) then
    vim.notify("Python-venvs - no virtual_envs found", vim.log.levels.WARN)
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