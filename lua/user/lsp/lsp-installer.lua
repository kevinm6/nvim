-----------------------------------
-- File         : lsp-installer.lua
-- Description  : Lsp-Installer config
-- Author       : Kevin
-- Last Modified: 22/04/2022 - 10:09
-------------------------------------

local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then return end

-- NEW CONFIGURATION OF NVIM-LSP-INSTALLER
lsp_installer.setup {
  ensure_installed = {
    "sumneko_lua", "vimls", "emmet_ls",
    "ltex", "pyright", "jsonls", "gopls",
    "html", "asm_lsp", "bashls", "clangd",
    "jdtls", "intelephense"
  },
  automatic_installation = false,
  ui = {
      icons = {
          -- The list icon to use for installed servers.
          server_installed = "◍",
          -- The list icon to use for servers that are pending installation.
          server_pending = "◍",
          -- The list icon to use for servers that are not installed.
          server_uninstalled = "◍",
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
  -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },

  log_level = vim.log.levels.INFO,

  max_concurrent_installers = 3,
}

