 -------------------------------------
 -- File: vars.lua
 -- Description: K specific variables
 -- Author: Kevin
 -- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/vars.lua
 -- Last Modified: 20/12/21 - 09:43
 -------------------------------------


-- Section: Clipboard {
	vim.g.clipboard = {
		name = 'pbcopy',
		copy = {
		  ['+'] = 'pbcopy',
		  ['*'] = 'pbcopy',
		  ['"'] = 'pbcopy',
		},
		paste = {
		  ['+'] = 'pbpaste',
		  ['*'] = 'pbpaste',
		  ['"'] = 'pbpaste',
		},
		cache_enabled = 0,
  }
-- }


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
	vim.g.markdown_fenced_languages = {
		'html',
		'python',
		'zsh',
		'java',
		'c', 'C',
		'bash=sh',
		'json',
		'xml',
		'vim',
		'help',
		'javascript', 'js=javascript',
		'css',
		'changelog',
		'cpp',
		'pseudo',
		'php',
		'sql'
	}

	vim.g.markdown_folding = 1
	vim.g.rmd_include_html = 1

	vim.g.glow_binary_path = vim.env.HOME .. "/.local/bin"
-- }


-- Section: SESSION {
	vim.g.session_autosave = 'yes'
	vim.g.session_autoload = 'yes'
  vim.g.session_default_to_last = 1
-- }


-- Section: NETRW {
	vim.g.netrw_banner = 0 -- disabling banner
	vim.g.netrw_preview = 1 -- preview window in vertical split instead of horizontal
	vim.g.netrw_liststyle = 3 -- set tree as default list appearance
	vim.g.netrw_browse_split = 1 -- open files in vertical split
	vim.g.netrw_silent = 1 -- transfers silently (no statusline changes when obtaining files
	vim.g.netrw_winsize = 26
	vim.g.netrw_keepdir = 0 -- current dir & browsing dir synced
	vim.g.netrw_localcopydircmd = 'cp -r' -- enable recursive copy command
	vim.g.netrw_mousemaps = 1
-- }

