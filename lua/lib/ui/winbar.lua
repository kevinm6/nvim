-----------------------------------------
-- File         : winbar.lua
-- Description  : Personal winbar config w/ navic
-- Author       : Kevin Manca
-- Last Modified: 11 May 2024, 11:44
-----------------------------------------

local winbar = {
  ---filetypes to exclude
  to_exclude = {
    dashboard = true,
    alpha = true,
    WhichKey = true,
    lspinfo = true,
    TelescopePrompt = true,
    TelescopeResults = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    mason = true,
    noice = true,
    checkhealth = true,
    notify = true,
    cmpmenu = true,
    vim = true,
    oil = true,
    help = true,
    query = true,
    httpResult = true,
    dapui_hover = true,
    ["dap-float"] = true,
  },
}

---Check string is empty
---@param s string|nil
---@return boolean not_empty false for empty string | true otherwise
local function is_not_empty(s)
  return s ~= nil and s ~= ""
end

---Set highlights groups for WinBar
local function set_color_groups()
  vim.api.nvim_set_hl(0, "WinBar", { fg = "#6c6c6c", bg = "#1c1c1c", bold = true })
  vim.api.nvim_set_hl(0, "WinBarNC", { fg = "#3c3c3c", bg = "#1c1c1c", italic = true })
end

---Get Filename of current buffer
---@return string filename file name formatted with icon if available
local function get_filename()
  local default_file_icon = require("lib.icons").kind.File
  local filename = vim.fn.expand "%:t"

  if is_not_empty(filename) then
    local file_icon = ""
    local extension = vim.fn.expand "%:e"

    local has_devicons, dev_icons = pcall(require, "nvim-web-devicons")

    file_icon, _ =
      has_devicons and dev_icons.get_icon_color(filename, extension, { default = not is_not_empty(extension) })
        or default_file_icon,
      nil

    return string.format("%%#FileIconColor%s#%s%%* %s", extension, file_icon, filename)
  end
  return ""
end

---Get winbar with highlights and icons
---@return string winbar formatted and with relative highlights
local function get_winbar()
  local has_navic, navic = pcall(require, "nvim-navic")
  local location = has_navic and navic.get_location() or nil

  local fname = get_filename()

  return is_not_empty(location) and string.format("%s %%#NavicSeparator#|%%* %s", fname, location) or fname
end

---Define autocmds for load winbar module and initialize
function winbar.toggle()
  if vim.g.winbar ~= nil then
    vim.api.nvim_del_autocmd(vim.g.winbar)
    vim.wo.winbar = ""
    vim.g.winbar = nil
  else
    vim.api.nvim_create_autocmd({
      "CursorMoved",
      "ModeChanged",
      "BufEnter",
    }, {
      group = vim.api.nvim_create_augroup("_winbar", { clear = true }),
      callback = function(cb)
        if vim.g.winbar ~= nil then
          if not vim.api.nvim_win_get_config(0).relative ~= "" and not winbar.to_exclude[vim.bo.filetype] then
            vim.wo.winbar = get_winbar()
          end
        else
          set_color_groups()
          vim.g.winbar = cb.id
        end
      end,
    })
  end
end

vim.api.nvim_create_user_command("ToggleWinbar", function()
  winbar.toggle()
end, { desc = "Toggle Winbar" })

return winbar
