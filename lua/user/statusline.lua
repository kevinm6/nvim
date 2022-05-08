-------------------------------------
-- File         : statusline.lua
-- Description  : StatusLine config
-- Author       : Kevin Manca
-- Last Modified: 08/05/2022 - 13:07
-------------------------------------

local S = {}

local icons = require("user.icons")

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
	encoding = "%#StatusLineFFormatEncoding#",
	fformat = "%#StatusLineFFormatEncoding#",
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
	return (map[mode_code] == nil) and mode_code or map[mode_code]
end

-- Helper function to check window size
-- if 2 values are passed as args, returns true
--  if win_size is between or equal to one of the limits
local function win_is_smaller(width, width2)
	if width2 ~= nil then
		return vim.api.nvim_win_get_width(0) >= width and vim.api.nvim_win_get_width(0) <= width2
	end
	return vim.api.nvim_win_get_width(0) < width
end

-- filename (tail) for statusline
local function get_filename()
	return " %t "
end

-- location function (current row on total rows)
local function get_line_onTot()
	return win_is_smaller(preset_width.row_onTot) and " %#StatusLineGit#%l%#StatusLineFFormatEncoding#÷%L "
		or " row %#StatusLineGit#%l%#StatusLineFFormatEncoding#÷%L "
end

-- check availability of nvim-gps plugin
local ok, gps = pcall(require, "nvim-gps")
if not ok then
	vim.notify(" Error loading nvim_gps", "Error", { title = "Statusline", timeout = 1400 })
	return
end

-- get value from nvim-gps if available and window size is big enough
local function nvim_gps()
	return gps.is_available() and (not win_is_smaller(preset_width.gps_loc)) and gps.get_location() or ""
end

-- function lsp diagnostic
-- display diagnostic if enough space is available
-- based on win_size gps is empty
local function get_lsp_diagnostic()
	local do_not_show_diag = win_is_smaller(preset_width.diagnostic) and nvim_gps() ~= "" or win_is_smaller(90)

	local diagnostics = vim.diagnostic
	-- assign to relative vars the count of diagnostic
	local errors = #(diagnostics.get(0, { severity = diagnostics.severity.ERROR }))
	local warnings = #(diagnostics.get(0, { severity = diagnostics.severity.WARN }))
	local infos = #(diagnostics.get(0, { severity = diagnostics.severity.INFO }))
	local hints = #(diagnostics.get(0, { severity = diagnostics.severity.HINT }))

	local status_ok = (errors == 0) and (warnings == 0) and (infos == 0) and (hints == 0) or false

	-- display values only if there are any
  return status_ok and icons.diagnostics.status_ok or
    do_not_show_diag and icons.diagnostics.status_not_ok or string.format(
			"%s:%d %s:%d %s:%d %s:%d",
			icons.diagnostics.Error, errors,
			icons.diagnostics.Warning, warnings,
			icons.diagnostics.Information, infos,
			icons.diagnostics.Hint, hints
		)
end

-- Function of git status with gitsigns
local function get_git_status()
	local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
	local is_head_empty = signs.head ~= ""

	-- display based on sie of window
	if win_is_smaller(preset_width.git_branch) then
		return ""
	elseif win_is_smaller(preset_width.git_branch, preset_width.git_status_full) then
		return is_head_empty and string.format("  %s ", signs.head or "") .. "%1*" or ""
	else
		return is_head_empty
				and string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
			or ""
	end
end

-- Function return filetype with icon if available
local function get_filetype()
	local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
	local icon = require("nvim-web-devicons").get_icon(file_name, file_ext)
	local file_type = vim.bo.filetype

	return file_type == nil and icons.diagnostics.Error
		or icon == nil and string.format(" %s ", file_type)
		or string.format(" %s %s ", icon, file_type)
end

-- Statusline enabled
S.active = function()
	-- LeftSide
  local space = " "
  local currMode = colors.mode .. "%m%r" .. get_mode() .. icons.ui.SlChevronRight
	local git = colors.git .. get_git_status()
	local fname = colors.name .. get_filename()
	local endLeftSide = colors.empty .. icons.ui.SlArrowRight
	-- Center & separators
	local gps_out = colors.gps .. space .. nvim_gps()
	local sideSep = "%="
	local lsp_diag = get_lsp_diagnostic()
	-- RightSide
	local endRightSide = space .. colors.empty .. icons.ui.SlArrowLeft
	local fencoding = colors.encoding .. " %{&fileencoding?&fileencoding:&encoding} "
	local ftype = colors.ftype .. get_filetype()
	local fformat = colors.fformat .. " %{&ff} "
	local location = get_line_onTot()

	return table.concat({
		-- Left Side
		currMode,
		git,
		fname,
		endLeftSide,
		gps_out,

		-- Center & separators
		sideSep,
		lsp_diag,

		-- Right Side
		endRightSide,
		fencoding,
		ftype,
		fformat,
		location,
	})
end

-- Statusline disabled
-- display only filetype and current mode
S.disabled = function(name)
	return name == nil and (get_mode() .. colors.fformat .. "%= " .. get_filetype() .. " %=")
		or (get_mode() .. colors.fformat .. "%= " .. name .. " %=")
end

return S
