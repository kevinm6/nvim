-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 17 Jan 2023, 16:59
-----------------------------------------

local S = {}

local icons = require "user.icons"

local diag_cached = ""

S.session_name = ""

local preset_width = setmetatable({
  filename = 120,
  git_branch = 60,
  git_status_full = 110,
  diagnostic = 128,
  row_onTot = 100,
}, {
    __index = function()
      return 80
    end,
  })

local colors = {
  mode = "%#StatusLineMode#",
  git = "%#StatusLineGit#",
  diag = "%#StatusLineDiagnostic#",
  ftype = "%#StatusLineFileType#",
  empty = "%#StatusLineEmptyspace#",
  name = "%#StatusLineFileName#",
  encoding = "%#StatusLineFileEncoding#",
  fformat = "%#StatusLineFileFormat#",
  location = "%#StatusLineLocation#",
  session = "%#StatusLineSession#",
  Nmode = "%#Nmode#",
  Vmode = "%#Vmode#",
  Imode = "%#Imode#",
  Cmode = "%#Cmode#",
  Tmode = "%#Tmode#",
  ShellMode = "%#Tmode#",
}

local map = {
  ["n"] = colors.Nmode .. "NORMAL",
  ["no"] = colors.Nmode .. "O-PENDING",
  ["nov"] = colors.Nmode .. "O-PENDING",
  ["noV"] = colors.Nmode .. "O-PENDING",
  ["no\22"] = colors.Nmode .. "O-PENDING",
  ["niI"] = colors.Nmode .. "NORMAL",
  ["niR"] = colors.Nmode .. "NORMAL",
  ["niV"] = colors.Nmode .. "NORMAL",
  ["nt"] = colors.Nmode .. "NORMAL",
  ["v"] = colors.Vmode .. "VISUAL",
  ["vs"] = colors.Vmode .. "VISUAL",
  ["V"] = colors.Vmode .. "V-LINE",
  ["Vs"] = colors.Vmode .. "V-LINE",
  ["\22"] = colors.Vmode .. "V-BLOCK",
  ["\22s"] = colors.Vmode .. "V-BLOCK",
  ["s"] = colors.Vmode .. "SELECT",
  ["S"] = colors.Vmode .. "S-LINE",
  ["\19"] = colors.Vmode .. "S-BLOCK",
  ["i"] = colors.Imode .. "INSERT",
  ["ic"] = colors.Imode .. "INSERT",
  ["ix"] = colors.Imode .. "INSERT",
  ["R"] = colors.Tmode .. "REPLACE",
  ["Rc"] = colors.Tmode .. "REPLACE",
  ["Rx"] = colors.Tmode .. "REPLACE",
  ["Rv"] = colors.Tmode .. "V-REPLACE",
  ["Rvc"] = colors.Tmode .. "V-REPLACE",
  ["Rvx"] = colors.Tmode .. "V-REPLACE",
  ["c"] = colors.Cmode .. "COMMAND",
  ["cv"] = colors.Cmode .. "EX",
  ["ce"] = colors.Cmode .. "EX",
  ["r"] = colors.Tmode .. "REPLACE",
  ["rm"] = colors.Nmode .. "MORE",
  ["r?"] = colors.Nmode .. "CONFIRM",
  ["!"] = colors.ShellMode .. "SHELL",
  ["t"] = colors.Tmode .. "TERMINAL",
}

local function get_mode()
  local mode_code = vim.api.nvim_get_mode().mode
  return map[mode_code] or mode_code
end

-- Helper function to check window size
-- if 2 values are passed as args, returns true
--  if win_size is between or equal to one of the limits
-- (in lua, only nil and false are "FALSY", 0 and '' are true)
local function win_is_smaller(lower, upper)
  local win_size = vim.api.nvim_win_get_width(0)
  return upper and (win_size >= lower and win_size <= upper) or win_size < lower
end

-- filename (tail) for statusline
local function get_filename()
  return "%t "
end

-- location function (current row on total rows)
local function get_line_onTot()
  return win_is_smaller(preset_width.row_onTot) and " " .. colors.git ..  "%l" ..  colors.location .. "÷%L "
    or colors.location .. " row " .. colors.git .. "%l" .. colors.location .. "÷%L "
end


-- function lsp diagnostic
-- display diagnostic if enough space is available
-- based on win_size
local function get_lsp_diagnostic()
  local do_not_show_diag = win_is_smaller(preset_width.diagnostic) or win_is_smaller(90)

  local diagnostics = vim.diagnostic
  -- assign to relative vars the count of diagnostics
  local errors = #diagnostics.get(0, { severity = diagnostics.severity.ERROR })
  local warns = #diagnostics.get(0, { severity = diagnostics.severity.WARN })
  local infos = #diagnostics.get(0, { severity = diagnostics.severity.INFO })
  local hints = #diagnostics.get(0, { severity = diagnostics.severity.HINT })

  local status_ok = (errors == 0) and (warns == 0) and (infos == 0) and (hints == 0) or false

  local diag = string.format(
    "%s:%d %s:%d %s:%d %s:%d",
    icons.diagnostics.Error, errors,
    icons.diagnostics.Warning, warns,
    icons.diagnostics.Information, infos,
    icons.diagnostics.Hint, hints
  )

  if diag_cached ~= diag then diag_cached = diag end

  -- display values only if there are any
  return status_ok and colors.diag..icons.diagnostics.status_ok
    or do_not_show_diag and colors.diag..icons.diagnostics.status_not_ok
    or colors.diag..diag_cached
end

-- Function of git status with gitsigns
local function get_git_status()
  local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
  local no_changes = (not signs.added) and (not signs.changed) and (not signs.removed)

  -- display based on size of window
  --  if no changes, display only head (if available)
  if win_is_smaller(preset_width.git_branch) then
    return ""
  elseif win_is_smaller(preset_width.git_branch, preset_width.git_status_full) then
    return signs.head and string.format("  %s ", signs.head) or ""
  else
    return signs.head and no_changes and string.format("  %s ", signs.head)
      or signs.head and string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
  end
end

-- Function return filetype with icon if available
local function get_filetype()
  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  local icon = ""

  if has_devicons then icon = devicons.get_icon(file_name, file_ext) end
  local file_type = vim.bo.filetype

  return file_type and has_devicons and { icon = icon, name = file_type }
    or { name = file_type } or icons.diagnostics.Error
end

local function get_fencoding()
  return "%{&fileencoding?&fileencoding:&encoding}"
end

local function session_name()
  return S.session_name ~= "" and "Session: "..colors.session..S.session_name or nil
end


-- Statusline disabled
-- display only filetype and current mode
S.off = function(name)
  local ftype_name = get_filetype().name

  local special_filetypes = {
    alpha = icons.ui.Plugin.." Dashboard",
    oil = icons.documents.OpenFolder.." File Explorer",
    lazy = icons.ui.PluginManager.." Package Manager",
    lspinfo = icons.ui.Health .. " LSP Status",
    TelescopePrompt = icons.ui.Telescope.." Telescope",
    qf = icons.ui.Gear.." QuickFix",
    toggleterm = icons.misc.Robot.." Terminal",
    crunner = icons.ui.AltSlArrowRight.." CodeRunner",
  }
  local custom_ft = special_filetypes[ftype_name]
  return ("%s%s %%= %s%%="):format(get_mode(), colors.fformat, name or custom_ft or ftype_name)
end

-- Statusline enabled
S.on = function()
  -- LeftSide
  local currMode = "%m%r"
  local leftSide = ("%s%s%s%s%s%s%s %s%s%s%s %s"):format(
    colors.mode, currMode, get_mode(),
    colors.empty, icons.ui.SlEndLeft,
    colors.git, get_git_status(),
    colors.name, get_filename(),
    colors.empty, icons.ui.SlArrowRight,
    session_name() or ""
  )

  -- Middle
  local sideSep = "%="
  local center = (" %s%s "):format(
    sideSep, get_lsp_diagnostic()
  )

  -- RightSide
  local fformat = "%{&ff}"
  local ftype = get_filetype()

  -- Right Side
  local rightSide = ("%s%s%s%s %s%s  %s%s[%s] %s%s%s"):format(
    colors.empty, icons.ui.SlArrowLeft,
    colors.ftype, ftype.icon or "", ftype.name,
    colors.encoding, get_fencoding(),
    colors.fformat, fformat,
    get_line_onTot(),
    colors.empty, icons.ui.SlEndRight
  )

  return ("%s%s%s"):format(leftSide, center, rightSide)
end

local to_exclude = function()
  local special_ft = {
    alpha = true,
    NvimTree = true,
    packer = true,
    lspinfo = true,
    TelescopePrompt = true,
    Trouble = true,
    qf = true,
    toggleterm = true,
    lazy = true,
    crunner = true,
  }

  return special_ft[vim.bo.filetype]
end

S.get_statusline = function()
  if not to_exclude() then
    vim.wo.statusline = S.on()
  else
    vim.wo.statusline = S.off()
  end
end

return S
