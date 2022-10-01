-----------------------------------------
-- File         : statusline.lua
-- Description  : Personal statusline config
-- Author       : Kevin Manca
-- Last Modified: 12 Sep 2022, 10:58
-----------------------------------------

local S = {}

local icons = require "user.icons"

local navic_cached_loc = ""
local diag_cached = ""

local preset_width = setmetatable({
	filename = 120,
	git_branch = 60,
	git_status_full = 110,
	diagnostic = 128,
	row_onTot = 100,
	gps_loc = 80,
}, {
	__index = function()
		return 80
	end,
})

local colors = {
	mode = "%#StatusLineMode#",
	git = "%#StatusLineGit#",
	gps = "%#StatusLineGpsDiagnostic#",
	diag = "%#StatusLineGpsDiagnostic#",
	ftype = "%#StatusLineFileType#",
	empty = "%#StatusLineEmptyspace#",
	name = "%#StatusLineFileName#",
	encoding = "%#StatusLineFileEncoding#",
	fformat = "%#StatusLineFileFormat#",
  location = "%#StatusLineLocation#",
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
	return map[mode_code]
    or mode_code
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

-- TODO: add session name management
local function session_name()
  local has_session, s_name = pcall(require, "auto-session-library")
  return has_session and s_name.current_session_name() or ""
end


-- TODO: remove condition on Nvim 0.8
-- get value from nvim-navic if available and window size is enough
local function nvim_navic()
  local navic_ok, navic = pcall(require, "nvim-navic")
  if navic_ok and navic.is_available() then
    local navic_loc = navic.is_available() and navic.get_location() or ""
    if navic_cached_loc ~= navic_loc then
      navic_cached_loc = navic_loc
    end
  end
  return win_is_smaller(preset_width.gps_loc) and  "" or navic_cached_loc
end


-- function lsp diagnostic
-- display diagnostic if enough space is available
-- based on win_size gps is empty
local function get_lsp_diagnostic()
	local do_not_show_diag = win_is_smaller(preset_width.diagnostic) and navic_cached_loc ~= "" or win_is_smaller(90)

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
	return status_ok and icons.diagnostics.status_ok
		or do_not_show_diag and icons.diagnostics.status_not_ok
    or diag_cached
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
	local icon = require("nvim-web-devicons").get_icon(file_name, file_ext)
	local file_type = vim.bo.filetype

	return file_type and icon and string.format(" %s %s ", icon, file_type)
		or string.format(" %s ", file_type)
		or icons.diagnostics.Error
end

local function get_fencoding()
  return " %{&fileencoding?&fileencoding:&encoding}"
end

-- Statusline disabled
-- display only filetype and current mode
S.off = function(name)
  local ftype = get_filetype()

  local special_filetypes = {
    [" alpha "] = icons.ui.Plugin.." Dashboard",
    [" NvimTree "] = icons.documents.OpenFolder.." File Explorer",
    [" packer "] = icons.ui.Packer.." Package Manager",
    [" lspinfo "] = icons.ui.Health .. " LSP Status",
    [" lsp-installer "] = icons.ui.List.." LSP Manager",
    [" TelescopePrompt "] = icons.ui.Telescope.." Telescope",
    [" qf "] = icons.ui.Gear.." QuickFix",
    [" toggleterm "] = icons.misc.Robot.." Terminal",
    [" Outline "] = icons.ui.List.." SymbolsOutline",
    [" Jaq "] = icons.ui.BoldChevronRight .." Quick Run Code (Jaq) " .. icons.ui.BoldChevronLeft,
  }
  ftype = special_filetypes[get_filetype()]
	return name and
	 ("%s%s %%= %s%%="):format(get_mode(), colors.fformat, name) or
		 ("%s%s %%= %s %%="):format(get_mode(), colors.fformat, ftype)
end

-- Statusline enabled
S.on = function()
	-- LeftSide
	local currMode = "%m%r"
  local leftSide = ("%s%s%s%s%s%s%s %s%s%s%s"):format(
    colors.mode, currMode, get_mode(),
    colors.empty, icons.ui.SlEndLeft,
    colors.git, get_git_status(),
    colors.name, get_filename(),
    colors.empty, icons.ui.SlArrowRight
  )

  -- Middle
	local sideSep = "%="
  local center = function()
    if vim.fn.has "nvim-0.8" == 1 then
      return (" %s %s "):format(
        session_name(), sideSep, get_lsp_diagnostic()
      )
    else
      return (" %s%s %s %s "):format(
        colors.gps, nvim_navic(),
        sideSep,
        get_lsp_diagnostic()
      )
    end
  end

	-- RightSide
	local fformat = "%{&ff}"

    -- Right Side
  local rightSide = ("%s%s%s%s %s%s %s%s %s%s%s"):format(
    colors.empty, icons.ui.SlArrowLeft,
    colors.encoding, get_fencoding(),
    colors.ftype, get_filetype(),
    colors.fformat, fformat,
    get_line_onTot(),
    colors.empty, icons.ui.SlEndRight
  )

  return ("%s%s%s"):format(leftSide, center(), rightSide)
end

return S
