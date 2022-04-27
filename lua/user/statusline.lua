-------------------------------------
-- File         : statusline.lua
-- Description  : StatusLine config
-- Author       : Kevin Manca
-- Last Modified: 26/04/2022 - 09:45
-------------------------------------

local S = {}

local ok, gps = pcall(require, "nvim-gps")
if not ok then
	return
end

local icons = require "user.icons"

local max_width = setmetatable({
	filename = 120,
	git_status = 90,
	diagnostic = 90,
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
	["V"] = colors.Vmode ..  "V-LINE",
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

local function is_truncated(width)
	return vim.api.nvim_win_get_width(0) < width
end

local function get_filename()
	return is_truncated(max_width.filename) and " %t " or " %<%f "
end

local function get_line_onTot()
	return is_truncated(max_width.row_onTot) and " %#StatusLineGit#%l%#StatusLineFFormatEncoding#÷%L "
		or " row %#StatusLineGit#%l%#StatusLineFFormatEncoding#÷%L "
end

local function get_lsp_diagnostic()
	if is_truncated(max_width.diagnostic) then
		return ""
	end

	local diagnostics = vim.diagnostic.get(0)
	local count = { 0, 0, 0, 0 }

	for _, diagnostic in ipairs(diagnostics) do
		count[diagnostic.severity] = count[diagnostic.severity] + 1
	end

	local errors = icons.diagnostics.Error .. ":" .. (count[vim.diagnostic.severity.ERROR] or 0)
	local warnings = icons.diagnostics.Warning .. ":" .. (count[vim.diagnostic.severity.WARN] or 0)
	local infos = icons.diagnostics.Information .. ":" .. (count[vim.diagnostic.severity.INFO] or 0)
	local hints = icons.diagnostics.Hint .. ":" .. (count[vim.diagnostic.severity.HINT] or 0)

	return string.format("%s %s %s %s", errors, warnings, infos, hints)
end

local function get_git_status()
	local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
	local is_head_empty = signs.head ~= ""

	if is_truncated(max_width.git_status) then
		return is_head_empty and string.format("  %s ", signs.head or "") .. "%1*" or ""
	end

	return is_head_empty
			and string.format(" +%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
		or ""
end

local function get_filetype()
	local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
	local icon = require("nvim-web-devicons").get_icon(file_name, file_ext)
	local file_type = vim.bo.filetype

	if file_type == nil then
		return
	end
	return icon == nil and string.format(" %s ", file_type) or string.format(" %s %s ", icon, file_type)
end

local function nvim_gps()
	return gps.is_available() and (not is_truncated(max_width.gps_loc)) and " " .. gps.get_location() or ""
end

S.active = function()
	-- LeftSide
	local currMode = colors.mode .. "%m%r" .. get_mode() .. icons.ui.SlChevronRight
	local git = colors.git .. get_git_status()
	local fname = colors.name .. get_filename()
	local endLeftSide = colors.empty .. icons.ui.SlArrowRight
	-- Center & separators
	local gps_out = colors.gps .. nvim_gps()
	local sideSep = "%="
	local lsp_diag = get_lsp_diagnostic()
	-- RightSide
	local endRightSide = " " .. colors.empty .. icons.ui.SlArrowLeft
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

S.disabled = function(name)
  return name == nil and (get_mode() .. colors.ftype .. "%= " .. get_filetype() .. " %=") or
    (get_mode() .. colors.mode .. "%= " .. name .. " %=")
end

return S
