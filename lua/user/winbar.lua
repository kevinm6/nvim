local W = {}

local navic_cached_loc = ""

local function isempty(s)
  return s == nil or s == ""
end

local icons = require "user.icons"

local filename = function()
  local fname = vim.fn.expand "%:t"
  local extension = ""
  local file_icon = ""
  local file_icon_color = ""
  local default_file_icon = ""
  local default_file_icon_color = ""

  if not isempty(fname) then
    extension = vim.fn.expand "%:e"

    local default = false

    if isempty(extension) then
      extension = ""
      default = true
    end

    file_icon, file_icon_color = require("nvim-web-devicons").get_icon_color(fname, extension, { default = default })

    local hl_group = "FileIconColor" .. extension

    vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
    if file_icon == nil then
      file_icon = default_file_icon
      file_icon_color = default_file_icon_color
    end

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#StatuslineFileName#" .. fname .. "%*"
  end
end

-- TODO: this will be moved to winbar with Nvim 0.8
-- get value from nvim-gps if available and window size is big enough
local function nvim_navic()
  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and navic.is_available() then
    local navic_loc = not navic_ok and icons.ui.Error or navic.is_available() and navic.get_location() or ""
    if navic_cached_loc ~= navic_loc then
      navic_cached_loc = navic_loc
    end
  end

  local retval = filename()

  return (not isempty(navic_cached_loc) and string.format("%s %s %s", retval, icons.ui.ChevronRight, navic_cached_loc)) or
    retval
end

W.show = function()
  return nvim_navic()
end

return W
