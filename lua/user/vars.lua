-------------------------------------
-- File         : vars.lua
-- Description  : NeoVim & VimR global vars
-- Author       : Kevin
-- Last Modified: 12 Jun 2022, 13:30
-------------------------------------

_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/impatient/luacache_chunks',
  },
  modpaths = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/impatient/luacache_modpaths',
  }
}

-- embedded script highlighting
vim.g.vimsyn_embed = "lP"

-- Python
vim.g.python3_host_prog = "/usr/local/bin/python3.9"
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


-- Markdown
vim.g.markdown_fenced_languages = {
  "html",
  "python",
  "zsh",
  "java",
  "c", "C",
  "bash=sh",
  "json",
  "xml",
  "vim",
  "help",
  "javascript", "js=javascript",
  "css",
  "changelog",
  "cpp",
  "pseudocode",
  "php",
  "sql"
}

vim.g.markdown_folding = 0
vim.g.rmd_include_html = 1

vim.g.glow_binary_path = vim.env.HOME .. "/.local/bin"
vim.g.glow_border = "shadow"
vim.g.glow_style = "dark"


-- Session
vim.g.session_autosave = "yes"
vim.g.session_autoload = "yes"
vim.g.session_default_to_last = 1

