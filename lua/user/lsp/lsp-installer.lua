-----------------------------------
-- File         : lsp-installer.lua
-- Description  : Lsp-Installer config
-- Author       : Kevin
-- Last Modified: 18 Jul 2022, 16:32
-------------------------------------

local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then return end

local icons = require "user.icons"

-- NEW CONFIGURATION OF NVIM-LSP-INSTALLER
lsp_installer.setup {
  ensure_installed = {
    "sumneko_lua", "vimls", "emmet_ls",
    "ltex", "pyright", "jsonls", "gopls",
    "html", "asm_lsp", "bashls", "clangd",
    "jdtls", "intelephense", "grammarly"
  },
  automatic_installation = false,
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
      -- Keymap to expand a server in the UI
      toggle_server_expand = "<CR>",
      -- Keymap to install the server under the current cursor position
      install_server = "i",
      -- Keymap to reinstall/update the server under the current cursor position
      update_server = "u",
      -- Keymap to check for new version for the server under the current cursor position
      check_server_version = "c",
      -- Keymap to update all installed servers
      update_all_servers = "U",
      -- Keymap to check which installed servers are outdated
      check_outdated_servers = "C",
      -- Keymap to uninstall a server
      uninstall_server = "X",
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
  install_root_dir = vim.fn.stdpath("data") .. "/lsp_servers",

  log_level = vim.log.levels.INFO,

  max_concurrent_installers = 2,
}
