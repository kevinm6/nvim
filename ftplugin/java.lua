-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration (jdtls)
-- Author       : Kevin
-- Last Modified: 17 Jul 2022, 12:51
-------------------------------------

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("  Error on starting jdtls ", "Error")
  return
end

local home = os.getenv "HOME"

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/java/workspace/" .. project_name

local bundles = {
  vim.fn.glob(
    home ..
    "/.local/share/nvim/lsp_servers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/vscode-java-test/server/*.jar"), "\n"))

local config = {
  cmd = {
    "java",

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-javaagent:" .. home .. "/.local/share/nvim/lsp_servers/jdtls/lombok.jar",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    vim.fn.glob(
      home .. "/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
    ),

    "-configuration", vim.fn.expand "~/.local/share/nvim/lsp_servers/jdtls/config_mac",

    "-data", workspace_dir,
  },
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
  root_dir =  require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}) or vim.fn.getcwd(),
  single_file_support = true,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
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
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-18",
            path = "/usr/local/opt/java/libexec/openjdk.jdk/"
          },
          {
            name = "JavaSE-11",
            path = "/usr/local/opt/java11/libexec/openjdk.jdk/"
          },
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
      format = {
        enabled = true,
      },
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
    },
    extendedClientCapabilities = extendedClientCapabilities,
    codeGeneration = {
      generateComments = true,
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      useBlocks = true,
    },
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
    init_options = {
      jvm_args = "-javaagent:" .. home .."/.local/share/nvim/lsp_servers/jdtls/lombok.jar",
      workspace = workspace_dir .. project_name,
      bundles = bundles,
    },
    on_init = function(client)
      client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
    end
  },
}

-- UI
local finders = require'telescope.finders'
local sorters = require'telescope.sorters'
local actions = require'telescope.actions'
local pickers = require'telescope.pickers'
require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
  local opts = {}
  pickers.new(opts, {
    prompt_title = prompt,
    finder    = finders.new_table {
      results = items,
      entry_maker = function(entry)
        return {
          value = entry,
          display = label_fn(entry),
          ordinal = label_fn(entry),
        }
      end,
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
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

vim.cmd(
  "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
)
vim.cmd(
  "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
)
vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

require('jdtls').start_or_attach(config)

local which_key_ok, which_key = pcall(require, "which-key")
if not which_key_ok then return end

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local vopts = {
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  J = {
    name = "Java",
    o = { function() require("jdtls").organize_imports() end, "Organize Imports" },
    v = { function() require("jdtls").extract_variable() end, "Extract Variable" },
    c = { function() require("jdtls").extract_constant() end, "Extract Constant" },
    t = {
      name = "Test (DAP)",
      c = { function() require("jdtls").test_class() end, "Class" },
      m = { function() require("jdtls").test_nearest_method() end, "Nearest Method" },
    }
  },
}

local vmappings = {
  J = {
    name = "Java",
    v = { function() require("jdtls").extract_variable(true) end, "Extract Variable" },
    c = { function() require("jdtls").extract_constant(true) end, "Extract Constant" },
    m = { function() require("jdtls").extract_method(true) end, "Extract Method" },
    t = {
      name = "Test (DAP)",
      c = { function() require("jdtls").test_class() end, "Class" },
      m = { function() require("jdtls").test_nearest_method() end, "Nearest Method" },
    },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
