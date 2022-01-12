 -------------------------------------
 -- File: vars.lua
 -- Description: K specific variables
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/vars.lua
 -- Last Modified: 12/01/22 - 13:53
 -------------------------------------


-- Section: Python {
	vim.g.python3_host_prog = "/usr/local/bin/python3.9"
-- }


-- Section: Database {
	vim.g.sql_type_default = 'postgresql'
	vim.g.omni_sql_no_default_maps = 1

	vim.g.dbs = {
		imdb = 'postgres://:@localhost/imdb',
		lezione = 'postgres://:@localhost/lezione'
	}
-- }


-- Section: Markdown {
	vim.g.glow_binary_path = vim.env.HOME .. "/.local/bin"
-- }


-- Section: SESSION {
	vim.g.session_autosave = 'yes'
	vim.g.session_autoload = 'yes'
  vim.g.session_default_to_last = 1
-- }

