-------------------------------------
-- File         : statusline.lua
-- Description  : StatusLine config
-- Author       : Kevin Manca
-- Last Modified: 25/04/2022 - 14:32
-------------------------------------

-- TODO: better management of colors instead of using "User#"

local S = {}

local ok, gps = pcall(require, "nvim-gps")
if not ok then
	return
end

local icons = require("user.icons")

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


local map = {
  ['n']      = '%#User1#NORMAL',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22'] = 'O-PENDING',
  ['niI']    = 'NORMAL',
  ['niR']    = 'NORMAL',
  ['niV']    = 'NORMAL',
  ['nt']     = 'NORMAL',
  ['v']      = '%#Todo#VISUAL',
  ['vs']     = 'VISUAL',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']   = 'V-BLOCK',
  ['\22s']  = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']   = 'S-BLOCK',
  ['i']      = 'INSERT',
  ['ic']     = 'INSERT',
  ['ix']     = 'INSERT',
  ['R']      = 'REPLACE',
  ['Rc']     = 'REPLACE',
  ['Rx']     = 'REPLACE',
  ['Rv']     = 'V-REPLACE',
  ['Rvc']    = 'V-REPLACE',
  ['Rvx']    = 'V-REPLACE',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPLACE',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERMINAL',
}

local function get_mode()
  local mode_code = vim.api.nvim_get_mode().mode
  if map[mode_code] == nil then
    return mode_code
  end
  return map[mode_code]
end


local function is_truncated(width)
	return vim.api.nvim_win_get_width(0) < width
end

local function get_filename()
	if is_truncated(max_width.filename) then
		return "%t"
	end
	return "%<%t"
end

local function get_line_onTot()
	if is_truncated(max_width.row_onTot) then
		return " %2*%l%3*÷%L "
	end
	return " row %2*%l%3*÷%L "
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
		return is_head_empty and string.format(" %s ", signs.head or "") .. "%1*"
			or ""
	end

	return is_head_empty
			and string.format("+%s ~%s -%s |  %s ", signs.added, signs.changed, signs.removed, signs.head)
		or ""
end


local function get_filetype()
  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  local icon = require("nvim-web-devicons").get_icon(file_name, file_ext)
  local file_type = vim.bo.filetype

  if file_type == nil then return end
  if icon == nil then
    return string.format("%s", file_type)
  else
    return string.format("%s %s", icon, file_type)
  end

end

local function nvim_gps()
	if gps.is_available() and not is_truncated(max_width.gps_loc) then
		return gps.get_location()
  else
    return ""
	end
end

S.active = function()
	-- LeftSide
	local currMode = "%#User1#%m%r" .. get_mode() .. icons.ui.SlChevronRight
	local git = "%#User2# " .. get_git_status()
	local fname = "%#User6# " .. get_filename()
	local endLeftSide = " %#User4#" .. icons.ui.SlArrowRight
	-- Center & separators
	local gps_out = "%#User5# " .. nvim_gps()
	local sideSep = "%="
	local lsp_diag = get_lsp_diagnostic()
	-- RightSide
	local endRightSide = " " .. "%#User4#" .. icons.ui.SlArrowLeft
	local fencoding = "%#User3# %{&fileencoding?&fileencoding:&encoding} "
	local ftype = "%#User1# " .. get_filetype()
	local fformat = "%#User3#  %{&ff} "
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
  return "%= " .. name .. " %="
end

return S
