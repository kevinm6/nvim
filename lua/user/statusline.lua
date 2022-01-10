 -------------------------------------
 -- File: statusline.lua
 -- Description:
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/statusline.lua
 -- Last Modified: 10/01/22 - 11:59
 -------------------------------------


-- Section: STATUS LINE {
	local M = {}

	M.trunc_width = setmetatable({
		filename = 120,
		git_status = 90,
		diagnostic = 120,
		row_onTot = 60,
	}, {
		__index = function()
			return 80
		end
	})


	M.is_truncated = function(_, width)
		local current_width = vim.api.nvim_win_get_width(0)
		return current_width < width
	end


	M.get_filename = function (self)
		if self:is_truncated(self.trunc_width.filename) then return "%t" end
		return "%<%f"
	end

	M.get_line_onTot = function(self)
		if self:is_truncated(self.trunc_width.row_onTot) then return '%l:%L ' end
		return 'row %l / %L '
	end

	M.get_lsp_diagnostic = function(self)
		local diagnostics = vim.diagnostic.get(0)
		local count = { 0, 0, 0, 0 }

		for _, diagnostic in ipairs(diagnostics) do
			count[diagnostic.severity] = count[diagnostic.severity] + 1
		end

		if self:is_truncated(self.trunc_width.diagnostic) then
			return "..."
		end

		return string.format(
			" X:%s !:%s ℹ:%s :%s ",
			count[vim.diagnostic.severity.ERROR] or 0, count[vim.diagnostic.severity.WARN] or 0,
			count[vim.diagnostic.severity.INFO] or 0, count[vim.diagnostic.severity.HINT] or 0
		)
	end


	M.get_git_status = function(self)
		local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
		local is_head_empty = signs.head ~= ''

		if self:is_truncated(self.trunc_width.git_status) then
			return is_head_empty and string.format(' %s', signs.head or '') or ''
		end

		return is_head_empty
			and string.format(
				'+%s ~%s -%s |  %s',
				signs.added, signs.changed, signs.removed, signs.head
			)
			or ''
	end

	M.active_status_line =  function(self)
		local bufN = '%1*%n⟩ '
		local git = '%2*'..self:get_git_status()
		local fname = '%1* ⟩ '..self:get_filename()..'%m '
		local endLeftSide =	'%4*'

		local sideSep = '%='
		local lspDiag = self:get_lsp_diagnostic()

		local endRightSide = '%4*'
		local fencoding = '%3* %{&fileencoding?&fileencoding:&encoding}'
		local ftype = '%1* %y'
		local fformat = '%3* ⟨ %{&ff}'
		local rowOnTot = ' ⟨ '..self:get_line_onTot()

		return table.concat({
			-- Left Side
			bufN, git, fname, endLeftSide,
			-- Center & separators
			sideSep, lspDiag, sideSep,
			-- Right Side
			endRightSide, fencoding, ftype,
			fformat, rowOnTot
		})
	end

  M.inactive_status_line = function(self)
    return '%= %f %='
  end

  M.explorer_status_line = function(self)
    return ' File Explorer '
  end


  Statusline = setmetatable(M, {
    __call = function(statusline, mode)
      if mode == "active" then return statusline:active_status_line() end
      if mode == "inactive" then return statusline:inactive_status_line() end
      if mode == "explorer" then return statusline:explorer_status_line() end
    end
  })


  vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
    au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
    augroup END
  ]], false)

-- }


