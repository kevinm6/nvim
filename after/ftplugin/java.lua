-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration (jdtls)
-- Author       : Kevin
-- Last Modified: 07 May 2024, 17:02
-------------------------------------

local has_jdtls, jdtls = pcall(require, 'jdtls')
if not has_jdtls then
  vim.notify(" ERROR loading jdtls", vim.log.levels.ERROR)
  return
end

-- local root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew",
--   "settings.gradle", "build.gradle" } or vim.uv.cwd()

local data_path = vim.fn.stdpath 'data'

local capabilities = vim.lsp.protocol.make_client_capabilities()
local extendedClientCapabilities = require 'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.document_formatting = false

local project_name = vim.fn.fnamemodify(vim.uv.cwd() or vim.fn.expand "%:p", ":p:h:t")
local workspace_dir = vim.fn.stdpath 'cache' .. "/java/workspace/" .. project_name

local launcher_path = vim.fn.glob(
  data_path .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true)
local bundles = vim.fn.glob(
  data_path ..
  "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  true, true)

local lombok_path = data_path .. "/mason/packages/jdtls/lombok.jar"

local os_uname, sys_config = vim.uv.os_uname(), nil
if os_uname.sysname == 'Darwin' then
  if os_uname.machine == 'arm64' then
    sys_config = 'mac_arm'
  else
    sys_config = 'mac'
  end
elseif os_uname.sysname == 'Linux' then
  sys_config = 'linux'
else
  vim.notify("Unsupported OS", vim.log.levels.WARN)
end

vim.list_extend(bundles,
  vim.split(
    vim.fn.glob(data_path .. "/mason/packages/java-test/extension/server/*.jar", true),
    "\n"))


local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    "-jar", launcher_path,

    "-javaagent", lombok_path,
    "-Xbootclasspath/a", lombok_path,

    "-configuration",
    (vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/config_") .. sys_config,
    "-data", workspace_dir,
  },
  capabilities = capabilities,
  -- root_dir = root_dir,
  single_file_support = true,
  settings = {
    java = {
      redhat = {
        telemetry = { enabled = false }
      },
      autobuild = { enabled = false },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      saveActions = {
        organizeImports = true
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        }
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
          },
          -- {
          --   name = "JavaSE-20",
          --   path = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
          -- },
        }
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = {
        enabled = true,
      },
      completion = {
        maxResults = 20,
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*", "sun.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        }
      },
      codeGeneration = {
        generateComments = true,
        toString = {
          template =
          "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
      }
    }
  },
  on_init = function(client)
    client.notify('workspace/didChangeConfiguration',
      { settings = client.config.settings })
  end,
  init_options = {
    -- jvm_args = "-javaagent:" .. vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    -- workspace = workspace_dir .. project_name,
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
    codelenses = {
      test = true,
      dynamicRegistration = true
    }
  },
  handlers = { -- ovverride to mute
    ["language/status"] = function() end,
  },
  on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    pcall(require "jdtls.dap".setup_dap_main_class_configs, {})
    require "jdtls.setup".add_commands()

    require("plugins.lsp").set_buf_keymaps(client, bufnr)
    require("plugins.lsp").set_buf_funcs_for_capabilities(client, bufnr)

    vim.api.nvim_create_autocmd('BufWritePost', {
      buffer = bufnr,
      callback = function()
        client.request_sync('java/buildWorkspace', false, 5000, bufnr)
      end
    })

    -- nvim-dap keymaps
    vim.keymap.set("n", "<localleader>df", function()
      jdtls.test_class()
    end, { buffer = bufnr, desc = "Java • Test class" })
    vim.keymap.set("n", "<localleader>dn", function()
      jdtls.test_nearest_method()
    end, { buffer = bufnr, desc = "Java • Test [n]ear method" })
  end
}

require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
  -- UI
  local finders = require 'telescope.finders'
  local sorters = require 'telescope.sorters'
  local actions = require 'telescope.actions'
  local pickers = require 'telescope.pickers'
  local opts = {}
  pickers.new(opts, {
    prompt_title    = prompt,
    finder          = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry),
        }
      end,
    },
    sorter          = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr)
      actions.goto_file_selection_edit:replace(function()
        local selection = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)

        cb(selection.value)
      end)

      return true
    end,
  }):find()
end

local icons = require 'lib.icons'

---LSP•Diagnostic
vim.diagnostic.config {
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint
    },
    numhl = {
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
    }
  },
  virtual_text = false,
  update_in_insert = false,
  underline = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    title = "LSP • Diagnostic",
    prefix = icons.lsp.nvim_lsp .. ' ',
    winblend = 8
  }
}

jdtls.start_or_attach(config)

-- Formatting
-- vim.api.nvim_buf_create_user_command(0,
--   "Format", function() vim.lsp.buf.formatting() end, { force = true }
-- )

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})