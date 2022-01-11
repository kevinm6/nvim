-------------------------------------
-- File: ltex.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/
-- Last Modified: 10/01/22 - 20:28
-------------------------------------

return {
		cmd = { "ltex-ls" },
		filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" },
		get_language_id = function(_, filetype)
			local language_id = language_id_mapping[filetype]
			if language_id then
				return language_id
			else
				return filetype
			end
		end,

		root_dir = function(path)
		-- Support git directories and git files (worktrees)
			if M.path.is_dir(M.path.join(path, '.git')) or M.path.is_file(M.path.join(path, '.git')) then
				return path
			end
		end,
    single_file_support = true
}

