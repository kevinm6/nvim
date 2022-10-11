local M = {}

local status_gps_ok, navic = pcall(require, "nvim-navic")
if not status_gps_ok then return end

local function isempty(s)
  return s == nil or s == ""
end

M.filename = function()
  local filename = vim.fn.expand "%:t"
  local extension = ""
  local file_icon = ""
  local file_icon_color = ""
  local default_file_icon = ""
  local default_file_icon_color = ""

  if not isempty(filename) then
    extension = vim.fn.expand "%:e"

    local default = false

    if isempty(extension) then
      extension = ""
      default = true
    end

    file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

    local hl_group = "FileIconColor" .. extension
    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })

    if file_icon == nil then
      file_icon = default_file_icon
      file_icon_color = default_file_icon_color
    end

    return string.format(" %%#%s#%s %s", hl_group, file_icon .. "%*", filename)
  end
end

M.gps = function()
  local status_ok, location = pcall(navic.get_location, {})
  if not status_ok then
    return
  end

  local icons = require "user.icons"

  if not navic.is_available() then -- Returns boolean value indicating whether a output can be provided
    return
  end

  local retval = M.filename()

  if location ~= "error" then
    return not isempty(location) and
      string.format("%s %s %s", retval, "%#NavicSeparator#"..icons.ui.ChevronRight.."%*", location) or
      retval
  else
    return
  end
end


M.get_winbar = function()
  local winbar_filetype_exclude = {
    ["help"] = true,
    ["dashboard"] = true,
    ["packer"] = true,
    ["NvimTree"] = true,
    ["Trouble"] = true,
    ["alpha"] = true,
    ["Outline"] = true,
    ["toggleterm"] = true,
    ["DressingSelect"] = true,
    ["Jaq"] = true,
    ["TelescopePrompt"] = true,
  }
  if winbar_filetype_exclude[vim.bo.filetype] then
    vim.opt_local.winbar = nil
  else
    vim.opt_local.winbar = M.gps()
  end
end

return M
