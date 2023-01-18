-------------------------------------
-- File         : vars.lua
-- Description  : NeoVim & VimR global vars
-- Author       : Kevin
-- Last Modified: 18 Jan 2023, 10:20
-------------------------------------

-- disable netrw
vim.g.loaded = 1
-- vim.g.loaded_netrwPlugin = 1

-- embedded script highlighting
vim.g.vimsyn_embed = "lP"

-- Providers
-- Python
vim.g.python3_host_prog = "~/.local/share/nvim/nvim_python_venv/bin/python"
-- }

-- Ruby (disable the provider)
vim.g.loaded_ruby_provider = 0

-- Perl (disable the provider)
vim.g.loaded_perl_provider = 0

-- Database
vim.g.sql_type_default = "postgresql"
vim.g.omni_sql_no_default_maps = 1

vim.g.dbs = {
  imdb = "postgres://:@localhost/imdb",
  lezione = "postgres://:@localhost/lezione"
}
vim.g.LanguageClient_serverCommands = {
  ["sql"] = {
    "sql-language-server", "up", "--method", "stdio"
  },
}

-- REPL (slime)
vim.g.slime_no_mappings = 1
vim.g.slime_target = "neovim"
