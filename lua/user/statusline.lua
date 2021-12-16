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
		git_status = 60,
		diagnostic = 80,
	}, {
		__index = function()
			return 80
		end
	})

	M.get_lsp_diagnostic = function()
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

		if M:is_truncated(M.trunc_width.diagnostic) then
			return is_head_empty and string.format(' %s', signs.head or '') or ''
		end

		return string.format(
			" X:%s !:%s ℹ:%s :%s ",
			result['errors'] or 0, result['warnings'] or 0,
			result['info'] or 0, result['hints'] or 0
		)
	end


	M.is_truncated = function(_, width)
		local current_width = vim.api.nvim_win_get_width(0)
		return current_width < width
	end

	M.get_git_status = function()
		local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
		local is_head_empty = signs.head ~= ''

		if M:is_truncated(M.trunc_width.git_status) then
			return is_head_empty and string.format(' %s', signs.head or '') or ''
		end

		return is_head_empty
			and string.format(
				'+%s ~%s -%s |  %s',
				signs.added, signs.changed, signs.removed, signs.head
			)
			or ''
	end

	M.status_line = function()


	end
	local stl = {
	-- Left Side
		"%1*%n⟩",
		'%2* '..M.get_git_status(),
		'%1* ⟩ %m %<%f  ',
		'%4*',
	-- Right Side
		'%='..M.get_lsp_diagnostic(),
		'%4*',
		'%3* %{&fileencoding?&fileencoding:&encoding}',
		'%1* %y',
		'%3* ⟨ %{&ff}',
		" ⟨ %l:%L "
	}
	vim.opt.statusline = table.concat(stl)
-- }


