local commands = require "lib.jupytext.commands"

local M = {}

local config = {
  source_extension = "ipynb",
  proxy_filetype = "quarto",
  output_extension = "qmd",
  custom_language_formatting = {
    python = { extension = "qmd", style = "quarto", force_ft = "quarto" }
  },
}

-----------------
---Utils
-----------------
local uv = vim.uv

---Debounce function on set amount of time
---@param fn function the function to debounce
---@param ms number milliseconds of debounce
---@return function
local function debounce(fn, ms)
  local timer = nil
  ms = ms or 300

  return function(...)
    local args = { ... }

    if timer then
      timer:stop()
      timer:close()
    end

    timer = uv.new_timer()
    if not timer then return end
    timer:start(ms, 0, function()
      timer:close()
      timer = nil
      vim.schedule(function()
        fn(unpack(args))
      end)
    end)
  end
end

local function get_state(bufnr)
  local ok, state = pcall(vim.api.nvim_buf_get_var, bufnr, "jupytext")
  if not ok then
    return nil
  end
  return state
end

local function set_state(bufnr, state)
  vim.api.nvim_buf_set_var(bufnr, "jupytext", state)
end


-----------------
---Management
-----------------

---Sync back qmd changes to jupiter-notebook
---@param bufnr number the buffer identifier
local function sync_back(bufnr)
  local state = get_state(bufnr)
  if not state then return end

  commands.run_jupytext(state.qmd, {
    ["--to"] = config.source_extension,
    ["--output"] = state.ipynb,
  }, { sync = false, context = "sync back" })
end

---Debounced write-back (300ms)
---@param bufnr number the buffer identifier
local debounced_sync = debounce(function(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    sync_back(bufnr)
  end
end, 300)

local function create_temp_qmd(ipynb_path)
  local tmpdir = vim.fn.stdpath("run")
  local qmd_path = ("%s/%s.%s"):format(tmpdir, vim.fn.fnamemodify(ipynb_path, ":t:r"), config.output_extension)
  local qmd_file = vim.fn.resolve(qmd_path)

  commands.run_jupytext(ipynb_path, {
    ["--to"] = config.output_extension .. ":" .. config.proxy_filetype,
    ["--output"] = qmd_file
  }, { context = "open proxy" })

  return qmd_file
end

local function open_proxy(ipynb_buf)
  local ipynb_path = vim.api.nvim_buf_get_name(ipynb_buf)
  local ipynb = vim.fn.resolve(ipynb_path)

  -- convert to temp qmd
  local qmd_path = create_temp_qmd(ipynb)
  local lines = vim.fn.readfile(qmd_path)
  assert(#lines > 0, "Generated qmd file is empty: " .. qmd_path)

  -- open qmd in a new buffer
  vim.cmd.edit(vim.fn.fnameescape(qmd_path))
  local qmd_buf = vim.api.nvim_get_current_buf()
  vim.bo.filetype = config.proxy_filetype

  set_state(qmd_buf, { ipynb = ipynb, qmd = qmd_path })

  -- deferred close the original ipynb buffer, not mess with filesystem plugins
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(ipynb_buf) then
      vim.api.nvim_buf_delete(ipynb_buf, { force = true })
    end

    if not vim.api.nvim_buf_is_valid(qmd_buf) then return end

    --HACK
    --this nested autocmd is a workaround to register correctly 'BufWritePost' for the proxy buffer
    --w/o it is not attached to its buffer and so never fires
    vim.api.nvim_create_autocmd("BufModifiedSet", {
      buffer = qmd_buf,
      callback = function(ev)
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = vim.api.nvim_create_augroup("jupytext-nvim", { clear = true }),
          buffer = ev.buf,
          callback = function(e)
            if not get_state(e.buf) then return end
            debounced_sync(e.buf)
          end,
        })
      end
    })

    vim.api.nvim_create_autocmd("BufWipeout", {
      group = vim.api.nvim_create_augroup("jupytext-nvim", { clear = true }),
      buffer = qmd_buf,
      callback = function(ev)
        local state = get_state(ev.buf)
        if not state then return end

        -- final sync
        sync_back(ev.buf)

        -- cleanup
        vim.schedule(function() vim.fn.delete(state.qmd) end)
      end,
    })
  end)
end

-----------------
---Setup
-----------------
M.start = function()
  assert(vim.fn.executable("jupytext") == 1, "Jupytext is not available: install via `pip install jupytext`")
  local augroup = vim.api.nvim_create_augroup("jupytext-nvim", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    pattern = { "*." .. config.source_extension },
    callback = function(ev)
      open_proxy(ev.buf)
    end
  })
end

return M
