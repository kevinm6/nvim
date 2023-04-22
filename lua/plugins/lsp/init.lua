-------------------------------------
-- File         : init.lua
-- Description  : config all module to be imported
-- Author       : Kevin
-- Last Modified: 22 Apr 2023, 12:58
-------------------------------------

local icons = require "util.icons"
local servers_to_install = {
  "lua_ls", "vimls", "tsserver", "sqlls",
  "pyright", "jsonls", "gopls", "yamlls",
  "html", "asm_lsp", "bashls", "clangd",
  "intelephense", "ocamllsp", "erlangls"
}

local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  cmd = { "LspInfo", "LspStart", "LspInstallInfo" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      event = "BufReadPre",
      keys = {
        { "<leader>M", vim.cmd.Mason, desc = "Mason" }
      },
      opts = {
        install_root_dir = vim.fn.stdpath "data" .. "/mason",
        PATH = "append",

        ui = {
          border = "rounded",
          width = 0.7,
          height = 0.7,
          icons = {
            -- The list icon to use for installed servers.
            package_installed = icons.packer.done_sym,
            -- The list icon to use for servers that are pending installation.
            package_pending = icons.packer.working_sym,
            -- The list icon to use for servers that are not installed.
            package_uninstalled = icons.packer.removed_sym,
          },
          keymaps = {
            -- Keymap to expand a server in the UI
            toggle_package_expand = "<CR>",
            -- Keymap to install the server under the current cursor position
            install_package = "i",
            -- Keymap to reinstall/update the server under the current cursor position
            update_server = "u",
            -- Keymap to check for new version for the server under the current cursor position
            check_package_version = "c",
            -- Keymap to update all installed servers
            update_all_packages = "U",
            -- Keymap to check which installed servers are outdated
            check_outdated_packages = "C",
            -- Keymap to uninstall a server
            uninstall_package = "D",
            -- Keymap to cancel a package installation
            cancel_installation = "<C-c>",
            -- Keymap to apply language filter
            apply_language_filter = "<C-f>",
          },
        },
        pip = {
          upgrade_pip = false,
          install_args = {},
        },
        max_concurrent_installers = 4,
        registries = {
          "lua:mason-registry.index",
          "github:mason-org/mason-registry",
        },
        providers = {
          "mason.providers.registry-api",
          "mason.providers.client",
        },
        github = {
          -- The template URL to use when downloading assets from GitHub.
          -- The placeholders are the following (in order):
          -- 1. The repository (e.g. "rust-lang/rust-analyzer")
          -- 2. The release version (e.g. "v0.3.0")
          -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
          download_url_template = "https://github.com/%s/releases/download/%s/%s",
        },
        log_level = vim.log.levels.INFO,
      }
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = servers_to_install,
        automatic_installation = {},
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
        pip = {
          install_args = {},
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 2,
      }
    },
    "hrsh7th/cmp-nvim-lsp",
    "jose-elias-alvarez/null-ls.nvim",
    -- "SmiteshP/nvim-navic",
  }
}

function M.config()
  local lspconfig = require "lspconfig"

  -- Update capabilities with extended
  local ext_capabilities = vim.lsp.protocol.make_client_capabilities()
  ext_capabilities = require "cmp_nvim_lsp".default_capabilities(ext_capabilities)
  ext_capabilities.textDocument.completion.completionItem.snippetSupport = true

   -- HACK: this is to avoid errors on lsp that support only single encoding (ex: clangd)
  ext_capabilities.offsetEncoding = 'utf-8'

  -- Custom configs to apply when starting lsp
  local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end

  -- Custom configs to apply when attaching lsp to buffer
  local custom_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require "nvim-navic".attach(client, bufnr)
    end

    -- require "inlay-hints".on_attach(client, bufnr)
    require "plugins.lsp.handlers".setup()
    require "plugins.lsp.codelens".run()
  end

  local default_lsp_config = {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = ext_capabilities,
    flags = { debounce_text_changes = 150 }
  }

  -- Manage handlers w/ Mason-lspconfig
  require "mason-lspconfig".setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name)
      if server_name ~= "jdtls" then
        lspconfig[server_name].setup(default_lsp_config) -- default handler (optional)
      end
    end,

    -- Next, you can provide targeted overrides for specific servers.
    -- Manage server with custom setup
    ["lua_ls"] = function() lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_lsp_config,
      require "plugins.lsp.configs.lua_ls"))
    end,
    ["jsonls"] = function() lspconfig.jsonls.setup(vim.tbl_deep_extend("force", default_lsp_config,
      require "plugins.lsp.configs.jsonls"))
    end,
    ["sqlls"] = function() lspconfig.sqlls.setup(vim.tbl_deep_extend("force", default_lsp_config,
      require "plugins.lsp.configs.sqlls"))
    end,
    ["grammarly"] = function() lspconfig.grammarly.setup(vim.tbl_deep_extend("force", default_lsp_config,
      { autostart = false }))
    end,
    ["clangd"] = function() lspconfig.clangd.setup(vim.tbl_deep_extend("force", default_lsp_config,
      require "plugins.lsp.configs.clangd"))
    end,
    ["gopls"] = function() lspconfig.gopls.setup(vim.tbl_deep_extend("force", default_lsp_config,
      require "plugins.lsp.configs.gopls"))
    end,
    -- ["tsserver"] = function() lspconfig.tsserver.setup(vim.tbl_deep_extend("force", default_lsp_config,
    --   require "plugins.lsp.configs.tsserver"))
    -- end,
  }

  -- sourcekit is still not available on mason-lspconfig
  lspconfig.sourcekit.setup(
    vim.tbl_deep_extend("force", default_lsp_config, require "plugins.lsp.configs.sourcekit")
  )

  require "plugins.lsp.null-ls".init(default_lsp_config)
end

return M
