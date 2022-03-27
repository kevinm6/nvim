 -------------------------------------
 -- File: statusline.lua
 -- Description: StatusLine config
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/statusline.lua
 -- Last Modified: 12/03/2022 - 17:34
 -------------------------------------


local ok, gps = pcall(require, "nvim-gps")
if not ok then return end

local icons = require "user.icons"

local trunc_width = setmetatable({
	filename = 120,
	git_status = 90,
	diagnostic = 130,
	row_onTot = 60,
	gps_loc = 80,
}, {
	__index = function()
		return 80
	end
})


local function is_truncated(width)
	local current_width = vim.api.nvim_win_get_width(0)
	return current_width < width
end


local function get_filename()
	if is_truncated(trunc_width.filename) then return "%t" end
	return "%<%f"
end


local function get_line_onTot()
	if is_truncated(trunc_width.row_onTot) then return " %2*%l%3*÷%L " end
	return " row %2*%l%3*÷%L "
end


local function get_lsp_diagnostic()
	if is_truncated(trunc_width.diagnostic) then return "" end

	local diagnostics = vim.diagnostic.get(0)
	local count = { 0, 0, 0, 0 }

	for _, diagnostic in ipairs(diagnostics) do
		count[diagnostic.severity] = count[diagnostic.severity] + 1
	end

	local errors = icons.diagnostics.Error .. ":" .. (count[vim.diagnostic.severity.ERROR] or 0)
	local warnings = icons.diagnostics.Warning .. ":" .. (count[vim.diagnostic.severity.WARN] or 0)
	local infos = icons.diagnostics.Warning .. ":" .. (count[vim.diagnostic.severity.INFO] or 0)
	local hints = icons.diagnostics.Hint .. ":" .. (count[vim.diagnostic.severity.HINT] or 0)

	return string.format(
		 "%s %s %s %s",
		 errors, warnings, infos, hints)
end


local function get_git_status()
	local signs = vim.b.gitsigns_status_dict or {head = "", added = 0, changed = 0, removed = 0}
	local is_head_empty = signs.head ~= ""

	if is_truncated(trunc_width.git_status) then
		return is_head_empty and string.format(" %s ", signs.head or "") or ""
	end

	return is_head_empty
		and string.format(
			"+%s ~%s -%s |  %s ",
			signs.added, signs.changed, signs.removed, signs.head
		) or ""
end


local	function nvim_gps()
	if (not gps.is_available()) or (is_truncated(trunc_width.gps_loc)) then return "" end
	return gps.get_location()
end


Statusline = {}

Statusline.active = function()
	-- LeftSide
	local bufN = '%1*%n' .. icons.ui.SlChevronRight
	local git = '%2*'.. get_git_status()
	local fname = '%1*' .. icons.ui.SlChevronRight .. ' ' .. get_filename() .. '%m '
	local endLeftSide =	'%4*' .. icons.ui.SlArrowRight
	-- Center & separators
	local sideSep = '%='
	-- RightSide
	local endRightSide = '%4*' .. icons.ui.SlArrowLeft
	local fencoding = '%3* %{&fileencoding?&fileencoding:&encoding}'
	local ftype = '%1* %y'
	local fformat = '%3* ' .. icons.ui.SlChevronLeft .. ' %{&ff}'

	return table.concat({
		-- Left Side
		bufN, " ", git, fname, endLeftSide, " ", nvim_gps(),
		-- Center & separators
		sideSep,
		get_lsp_diagnostic(), " ",
		-- Right Side
		endRightSide, fencoding, ftype,
		fformat, " ", icons.ui.SlChevronLeft .. get_line_onTot()
	})
end


function Statusline.inactive()
	return "%= %f %="
end


function Statusline.explorer()
	return "%= File Explorer %="
end


function Statusline.dashboard()
	return "%= Dashboard %="
end


vim.api.nvim_exec([[
	augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    au FileType,BufEnter,WinEnter neo-tree setlocal statusline=%!v:lua.Statusline.explorer()
    au FileType,BufEnter,WinEnter alpha setlocal statusline=%!v:lua.Statusline.dashboard()
	augroup END
]], false)

