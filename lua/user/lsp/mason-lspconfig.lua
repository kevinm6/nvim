-----------------------------------
-- File         : mason-lspconfig.lua
-- Description  : mason-lspconfig setup
-- Author       : Kevin
-- Last Modified: 16 Oct 2022, 10:45
-------------------------------------

local ok, mason_lsp = pcall(require, "mason-lspconfig")
if not ok then return end

local icons = require "user.icons"

local servers_to_install = {
  "lua-language-server", "vimls", "emmet_ls",
  "ltex", "pyright", "jsonls", "gopls",
  "html", "asm_lsp", "bashls", "clangd",
 "intelephense", "grammarly",
  "ocaml-lsp", "erlang-ls"
}


mason_lsp.setup {
  ensure_installed = servers_to_install,
  automatic_installation = { exclude = { "julia" } },
  ui = {
    border = "rounded",
    icons = {
      -- The list icon to use for installed servers.
      server_installed = icons.packer.done_sym,
      -- The list icon to use for servers that are pending installation.
      server_pending = icons.packer.working_sym,
      -- The list icon to use for servers that are not installed.
      server_uninstalled = icons.packer.removed_sym,
    },
    keymaps = {
      toggle_server_expand = "<CR>", -- Keymap to expand a server in the UI
      install_server = "i", -- Keymap to install the server under the current cursor position
      update_server = "u", -- Keymap to reinstall/update the server under the current cursor position
      check_server_version = "c", -- Keymap to check for new version for the server under the current cursor position
      update_all_servers = "U", -- Keymap to update all installed servers
      check_outdated_servers = "C", -- Keymap to check which installed servers are outdated
      uninstall_server = "X", -- Keymap to uninstall a server
    },
  },
  github = {
    -- The template URL to use when downloading assets from GitHub.
    -- The placeholders are the following (in order):
    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
    -- 2. The release version (e.g. "v0.3.0")
    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
    download_url_template = "https://github.com/%s/releases/download/%s/%s",
  },
  pip = {
    install_args = {},
  },

  log_level = vim.log.levels.INFO,

  max_concurrent_installers = 2,
}

