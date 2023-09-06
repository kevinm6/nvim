-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration (jdtls)
-- Author       : Kevin
-- Last Modified: 01 Oct 2023, 02:31
-------------------------------------

local has_jdtls, jdtls = pcall(require, "jdtls")
if not has_jdtls then
  vim.notify(" ERROR loading jdtls", vim.log.levels.ERROR)
  return
end

local root_dir = require("jdtls.setup").find_root {".git", "gradlew", "settings.gradle", "build.gradle"}
if root_dir == "" then root_dir = vim.fn.getcwd() end

local data_path = vim.fn.stdpath "data"

local capabilities = vim.lsp.protocol.make_client_capabilities()
local extendedClientCapabilities = require "jdtls".extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.document_formatting = false

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/java/workspace/" .. project_name

local launcher_path = vim.fn.glob(
  data_path.."/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
  true, true)[1]
local bundles = vim.fn.glob(
  data_path.."/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true, true)


local lombok_path = data_path.."/mason/packages/jdtls/lombok.jar"

local os_name = "mac"
if vim.fn.has "mac" == 1 then
  os_name = "mac"
elseif vim.fn.has "unix" == 1 then
  os_name = "linux"
else
  vim.notify("Unsupported OS", vim.log.levels.WARN)
end

vim.list_extend(bundles, vim.split(vim.fn.glob(data_path.."/mason/packages/java-test/extension/server/*.jar", true), "\n"))

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

    "-configuration", (vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/config_" )..os_name,

    "-data", workspace_dir,
  },
  capabilities = capabilities,
  root_dir = root_dir,
  single_file_support = true,
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
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
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
          },
          -- TODO: add latest when it will be updated
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
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
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
  },
  on_init = function(client)
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
  init_options = {
    -- jvm_args = "-javaagent:" .. vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    -- workspace = workspace_dir .. project_name,
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
    codelenses = {
      test = true,
      dynamicRegistration = true
    },
  },
  handlers = { -- ovverride to mute
    ["language/status"] = function() end,
    -- ["textDocument/codeAction"] = function() end,
    -- ["textDocument/rename"] = function() end,
    -- ["workspace/applyEdit"] = function() end,
    ["textDocument/documentHighlight"] = function() end,
  },
  on_attach = function ()
    require "jdtls".setup_dap { hotcodereplace = "auto" }
    require "jdtls.dap".setup_dap_main_class_configs()
    require "jdtls.setup".add_commands()
  end
}

-- -- UI
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

jdtls.start_or_attach(config)

vim.cmd([[
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
  ]])
vim.cmd([[
  command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
  ]])

vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

-- useful keymaps for java
vim.keymap.set("n", "ø", function() require "jdtls".organize_imports() end, { buffer = true })
vim.keymap.set({ "v", "n" }, "crv", function() require "jdtls".extract_variable(true) end, { buffer = true, desc = "Extract variable" })
vim.keymap.set({ "v", "n" }, "crc", function() require "jdtls".extract_constant(true) end, { buffer = true, desc = "Extract constant" })
vim.keymap.set("v", "crm", function() require "jdtls".extract_method(true) end, { buffer = true, desc = "Extract method" })

-- Formatting
vim.api.nvim_buf_create_user_command(0,
  "Format", function() vim.lsp.buf.formatting() end, { force = true }
)


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
   pattern = { "*.java" },
   callback = function()
      vim.lsp.codelens.refresh()
   end,
})

-- nvim-dap keymaps
vim.keymap.set("n", "<leader>df", function() require "jdtls".test_class() end, { buffer = true, desc = "Test class" })
vim.keymap.set("n", "<leader>dn", function() require "jdtls".test_nearest_method() end, { buffer = true, desc = "Test near method" })

-- standard lsp keymaps (added because nvim-jdlts do not call LspAttach event for set keymaps)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { buffer = true, desc = "Open float" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = true, desc = "GoTo definition" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = true , desc = "GoTo implementation"})
vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = true , desc = "GoTo references"})
