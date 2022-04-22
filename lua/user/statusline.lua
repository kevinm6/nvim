-------------------------------------
-- File         : statusline.lua
-- Description  : StatusLine config
-- Author       : Kevin
-- Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/statusline.lua
-- Last Modified: 20/04/2022 - 15:57
-------------------------------------

local Statusline = {}

local ok, gps = pcall(require, "nvim-gps")
if not ok then
	return
end

local icons = require("user.icons")

local max_width = setmetatable({
	filename = 120,
	git_status = 90,
	diagnostic = 90,
	row_onTot = 60,
	gps_loc = 80,
}, {
	__index = function()
		return 80
	end,
})

local is_truncated = function(width)
	return vim.api.nvim_win_get_width(0) < width
end

local get_filename = function()
	if is_truncated(max_width.filename) then
		return "%t"
	end
	return "%<%t"
end

local get_line_onTot = function()
	if is_truncated(max_width.row_onTot) then
		return " %2*%l%3*÷%L "
	end
	return " row %2*%l%3*÷%L "
end

local get_lsp_diagnostic = function()
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
	local infos = icons.diagnostics.Warning .. ":" .. (count[vim.diagnostic.severity.INFO] or 0)
	local hints = icons.diagnostics.Hint .. ":" .. (count[vim.diagnostic.severity.HINT] or 0)

	return string.format("%s %s %s %s", errors, warnings, infos, hints)
end

local get_git_status = function()
	local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
	local is_head_empty = signs.head ~= ""

	if is_truncated(max_width.git_status) then
		return is_head_empty and string.format(" %s ", signs.head or "") .. "%1*" .. icons.ui.SlChevronRight .. " "
			or ""
	end

	return is_head_empty
			and string.format("+%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head) .. "%1*" .. icons.ui.SlChevronRight .. " "
		or ""
end

local nvim_gps = function()
	if gps.is_available() and (not is_truncated(max_width.gps_loc)) then
		return gps.get_location()
	else
		return ""
	end
end

function Statusline.active()
	-- LeftSide
	local bufN = "%#User1#%n%m" .. icons.ui.SlChevronRight
	local git = "%#User2#" .. get_git_status()
	local fname = "%#User6#" .. get_filename()
	local endLeftSide = "%#User4#" .. icons.ui.SlArrowRight
	-- Center & separators
	local gps_out = "%#User5#" .. nvim_gps()
	local sideSep = "%="
	local lsp_diag = get_lsp_diagnostic()
	-- RightSide
	local endRightSide = "%#User4#" .. icons.ui.SlArrowLeft
	local fencoding = "%#User3# %{&fileencoding?&fileencoding:&encoding}"
	local ftype = "%#User1# %y"
	local fformat = "%#User3# " .. icons.ui.SlChevronLeft .. " %{&ff}"
	local location = icons.ui.SlChevronLeft .. get_line_onTot()

	return table.concat({
		-- Left Side
		bufN,
		" ",
		git,
		fname,
		endLeftSide,
		" ",
		gps_out,
		-- Center & separators
		sideSep,
		lsp_diag,
		" ",
		-- Right Side
		endRightSide,
		fencoding,
		ftype,
		fformat,
		" ",
		location,
	})
end

function Statusline.explorer()
	return "%= File Explorer %="
end

function Statusline.dashboard()
	return "%= Dashboard %="
end

function Statusline.set(name)
	if name == "Explorer" then
    vim.api.nvim_set_option_value("statusline", Statusline.explorer(), { scope = 'global' })
	elseif name == "Dashboard" then
    vim.api.nvim_set_option_value("statusline", Statusline.explorer(), { scope = 'global' })
	else
    vim.api.nvim_set_option_value("statusline", Statusline.active(), { scope = 'global' })
	end
end

return Statusline
