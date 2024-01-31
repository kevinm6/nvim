-----------------------------------------
-- File         : winbar.lua
-- Description  : Personal winbar config w/ navic
-- Author       : Kevin Manca
-- Last Modified: 03 Dec 2023, 10:47
-----------------------------------------

local M = {
  dir = "~/.config/nvim/lua/plugins/ui/winbar.lua"
}

local function is_not_empty(s)
  return s ~= nil and s ~= ""
end

local function to_exclude(filetype)
  local special_ft = {
    dashboard = true,
    alpha = true,
    WhichKey = true,
    NvimTree = true,
    lspinfo = true,
    TelescopePrompt = true,
    TelescopeResults = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    Outline = true,
    noice = true,
    checkhealth = true,
    notify = true,
    cmpmenu = true,
    vim = true,
    oil = true,
    help = true,
    query = true,
  }

  return special_ft[filetype]
end

M.filename = function()
  local default_file_icon = require "lib.icons".kind.File
  local filename = vim.fn.expand "%:t"

  if is_not_empty(filename) then
    local file_icon = ""
    local extension = vim.fn.expand "%:e"

    file_icon, _ = require("nvim-web-devicons").get_icon_color(
      filename,
      extension,
      { default = not is_not_empty(extension) or false }
    )

    return string.format(
      "%%#FileIconColor%s#%s%%* %s",
      extension,
      file_icon or default_file_icon,
      filename
    )
  end
end

M.get = function()
  local icons = require "lib.icons"
  local has_navic, navic = pcall(require, "nvim-navic")
  local location = has_navic and navic.get_location() or nil

  -- WinBar = { fg = "#6c6c6c", bg = "#1c1c1c", italic = true },
  -- WinBarNC = { fg = "#3c3c3c", bg = "#1c1c1c" },
  local retval = M.filename()

  return is_not_empty(location)
    and string.format(
      "%s %%#NavicSeparator# %s %%* %s",
      retval,
      icons.ui.ChevronRight,
      location
    )
    or retval
end


M.toggle = function()
  if vim.g.winbar ~= nil then
    vim.api.nvim_del_autocmd(vim.g.winbar)
    vim.wo.winbar = ""
    vim.g.winbar = nil
  else
    vim.api.nvim_create_autocmd({
      "CursorMoved", "ModeChanged", "BufEnter"
    }, {
        callback = function(cb)
          if vim.g.winbar ~= nil then
            if
              not vim.api.nvim_win_get_config(0).relative ~= ""
              and not to_exclude(vim.bo.filetype)
            then
              vim.wo.winbar = require("config.winbar").get()
            end
          else
            vim.api.nvim_set_hl(0, "WinBar", { fg = "#6c6c6c", bg = "#1c1c1c", italic = true })
            vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#3c3c3c", bg = "#1c1c1c" })
            vim.g.winbar = cb.id
          end
        end
      })
  end
end

vim.api.nvim_create_user_command("ToggleWinbar", function()
  M.toggle()
end, { desc = "Toggle Winbar" })

return M