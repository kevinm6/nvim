 -------------------------------------
 -- File: statusline.lua
 -- Description:
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/statusline.lua
 -- Last Modified: 16/12/21 - 13:40
 -------------------------------------


-- Section: STATUS LINE {
	local M = {}

	M.trunc_width = setmetatable({
		git_status = 80,
		diagnostic = 60,
	}, {
		__index = function()
			return 80
		end
	})


	M.is_truncated = function(_, width)
		local current_width = vim.api.nvim_win_get_width(0)
		return current_width < width
	end


	M.get_lsp_diagnostic = function(self)
		local result = {}
		local levels = {
			errors = 'Error',
			warnings = 'Warning',
			info = 'Information',
			hints = 'Hint'
		}

		for k, level in pairs(levels) do
			result[k] = vim.lsp.diagnostic.get_count(0, level)
		end

		if self:is_truncated(self.trunc_width.diagnostic) then
			return ". . ."
		end

		return string.format(
			" X:%s !:%s ℹ:%s :%s ",
			result['errors'] or 0, result['warnings'] or 0,
			result['info'] or 0, result['hints'] or 0
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

	M.status_line = function(self)
		local bufN = "%1*%n⟩ "
		local git = "%2*"..self:get_git_status()
		local fname = "%1* ⟩ %m %<%f  "
		local endLeftSide =	"%4*"

		local sideSep = "%="
		local lspDiag = self:get_lsp_diagnostic()

		local endRightSide = "%4*"
		local fencoding = "%3* %{&fileencoding?&fileencoding:&encoding}"
		local ftype = "%1* %y"
		local fformat = "%3* ⟨ %{&ff}"
		local rowOnRowTot = " ⟨ %l:%L "

		return table.concat({
			-- Left Side
			bufN, git, fname, endLeftSide,
			-- Center & separators
			sideSep, lspDiag, sideSep,
			-- Right Side
			endRightSide, fencoding, ftype,
			fformat, rowOnRowTot
		})
	end

	-- StatusLine = setmetatable(M, {
	-- 	__call = function(sl)
	-- 		return sl:status_line()
	-- 	end
	-- })

	vim.opt.statusline = M:status_line()

	-- vim.api.nvim_exec([[
	-- 	augroup Statusline
	-- 	au!
	-- 	au WinEnter,BufEnter setlocal statusline=%!v:lua.Statusline()
	-- 	augroup END
	-- ]], false)
-- }


