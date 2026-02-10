local M = {}

local function build_cmd(input, options)
  local cmd = { "jupytext", input }

  for option_name, option_value in pairs(options) do
    if option_value ~= "" then
      table.insert(cmd, ("%s=%s"):format(option_name, option_value))
    else
      table.insert(cmd, option_name)
    end
  end

  return cmd
end


local function log_error(msg)
  vim.api.nvim_echo({ { "[jupytext]", msg } }, true, { err = true })
end

local function log_info(msg)
  vim.api.nvim_echo({ { "[jupytext]", msg } }, true, {})
end

local function handle_result(res, context)
  if not res then return end

  if res.code ~= 0 then
    log_error(("failed (%s)\n%s"):format(
      context or "unknown",
      res.stderr or ""
    ))
  elseif res.stderr and res.stderr ~= "" then
    log_info(res.stderr)
  end
end

---Run command
---@param cmd table the command to run
---@param opts table<boolean,string>
local function run(cmd, opts)
  if opts.sync then
    local res = vim.system(cmd, { text = true }):wait()
    handle_result(res, opts.context)
    return res
  else
    local _ = vim.system(cmd, { text = true }, function(res)
      handle_result(res, opts.context)
      -- if on_exit then
      --   on_exit(res)
      -- end
    end)
  end
end

---Run jupytext command
---@param input_file string file to be used as input of jupytext command
---@param args table of extra args to be passed to jupytext command
---@param opts table opts with sync and context
local function run_jupytext_command(input_file, args, opts)
  local cmd = build_cmd(input_file, args)
  opts.sync = opts.sync or true
  opts.context = opts.context or nil
  run(cmd, opts)
end

M.run_jupytext = run_jupytext_command

return M