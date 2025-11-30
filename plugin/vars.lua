-------------------------------------
-- File         : vars.lua
-- Description  : NeoVim & VimR global vars
-- Author       : Kevin
-- Last Modified: 30 Nov 2025, 20:42
-------------------------------------

-- Disable unwanted plugins
vim.g.did_install_default_menus = 1
vim.g.loaded_netrwPlugin = 1
vim.g.tutor_is_loaded = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1

-- embedded script highlighting
vim.g.vimsyn_embed = "lP"

-- NeoVim Terminal colors
vim.g.terminal_color_0 = "#1c1c1c" -- black
vim.g.terminal_color_8 = "#626262" -- gray
vim.g.terminal_color_1 = "#bf616a" -- red
vim.g.terminal_color_9 = "#b2201f" -- bright-red
vim.g.terminal_color_2 = "#00af87" -- green
vim.g.terminal_color_10 = "#36f57a" -- bright-green
vim.g.terminal_color_3 = "#cecb00" -- yellow
vim.g.terminal_color_11 = "#fffd00" -- bright-yellow
vim.g.terminal_color_4 = "#158C8A" -- blue
vim.g.terminal_color_12 = "#1a8fff" -- bright-blue
vim.g.terminal_color_5 = "#B48EAD" -- purple
vim.g.terminal_color_13 = "#cb1ed1" -- bright-purple
vim.g.terminal_color_6 = "#1a8fff" -- cyan
vim.g.terminal_color_14 = "#14ffff" -- bright-cyan
vim.g.terminal_color_7 = "#dcdcdc" -- white
vim.g.terminal_color_15 = "#ffffff" -- bright-white

-- disable language Providers support (using only lua and vimscript plugins)
-- using python for `molten-nvim` and jupyter_notebook in Neovim
vim.g.python3_host_prog = vim.fn.stdpath "data" .. "/.venv/bin/python3.12"
vim.g.python_host_prog = vim.fn.stdpath "data" .. "/.venv/bin/python"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Database
vim.g.sql_type_default = "postgresql"
vim.g.omni_sql_no_default_maps = 1

--disable localisations on diff
vim.g.diff_translations = 0