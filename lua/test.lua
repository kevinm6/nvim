local M = {}

M.workon = function()
  local config = require('lazy.core.config')
  vim.ui.select(vim.tbl_values(config.plugins), {
    prompt = 'lcd to:',
    format_item = function(plugin)
      return string.format('%s (%s)', plugin.name, plugin.dir)
    end,
  }, function(plugin)
    if not plugin then
      return
    end
    vim.schedule(function()
      vim.cmd.lcd(plugin.dir)
    end)
  end)
end

return M
