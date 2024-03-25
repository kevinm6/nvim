-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration (jdtls)
-- Author       : Kevin
-- Last Modified: 19 Mar 2024, 17:00
-------------------------------------

local has_jdtls, jdtls = pcall(require, "jdtls")
if not has_jdtls then
  vim.notify(" ERROR loading jdtls", vim.log.levels.ERROR)
  return
end

local root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew",
  "settings.gradle", "build.gradle" } or vim.uv.cwd()

local data_path = vim.fn.stdpath "data"

local capabilities = vim.lsp.protocol.make_client_capabilities()
local extendedClientCapabilities = require "jdtls".extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.document_formatting = false

local project_name = vim.fn.fnamemodify(vim.uv.cwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "cache" .. "/java/workspace/" .. project_name

local launcher_path = vim.fn.glob(
  data_path .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true)
local bundles = vim.fn.glob(
  data_path ..
  "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  true, true)

local lombok_path = data_path .. "/mason/packages/jdtls/lombok.jar"

local os_name = "mac"
if vim.fn.has "mac" == 1 then
  os_name = "mac"
elseif vim.fn.has "unix" == 1 then
  os_name = "linux"
else
  vim.notify("Unsupported OS", vim.log.levels.WARN)
end

vim.list_extend(bundles,
  vim.split(
    vim.fn.glob(data_path .. "/mason/packages/java-test/extension/server/*.jar", true),
    "\n"))


local function set_keymaps(client, bufnr)
  local function nmap(keys, fun, desc)
    vim.keymap.set("n", keys, fun, { desc = desc, buffer = bufnr })
  end
  local function vmap(keys, fun, desc)
    vim.keymap.set("v", keys, fun, { desc = desc, buffer = bufnr })
  end
  local function nvmap(keys, fun, desc)
    vim.keymap.set({ "n", "v" }, keys, fun, { desc = desc, buffer = bufnr })
  end

  local has_telescope, tele_builtin = pcall(require, "telescope.builtin")
  if client.server_capabilities.declarationProvider then
    nmap("gD", function()
      if has_telescope then
        tele_builtin.lsp_definitions()
      else
        vim.lsp.buf.declaration()
      end
    end, "LSP Declaration")
  end
  if client.server_capabilities.definitionProvider then
    nmap("gd", function()
      if has_telescope then
        tele_builtin.lsp_definitions()
      else
        vim.lsp.buf.definition()
      end
    end, "LSP Definition")
  end
  if client.server_capabilities.implementationProvider then
    nmap("gI", function()
      if has_telescope then
        tele_builtin.lsp_incoming_calls {}
      else
        vim.lsp.buf.implementation()
      end
    end, "LSP IncCalls")
  end
  if client.supports_method "callHierarchy/outgoingCalls" then
    nmap("gC", function()
      if has_telescope then
        tele_builtin.lsp_outgoing_calls {}
      else
        vim.lsp.buf.outgoing_calls()
      end
    end, "LSP OutCalls")
  end
  if client.server_capabilities.referencesProvider then
    nmap("gr", function()
      if has_telescope then
        tele_builtin.lsp_references {}
      else
        vim.lsp.buf.references()
      end
    end, "LSP References")
  end

  nmap("gs", function()
    if has_telescope then
      tele_builtin.lsp_document_symbols()
    else
      vim.lsp.buf.document_symbol()
    end
  end, "LSP Symbols")

  nmap("<leader>lt", function()
    if has_telescope then
      tele_builtin.lsp_type_definitions()
    else
      vim.lsp.buf.type_definition()
    end
  end, "LSP TypeDef")

  nmap("<leader>lS", function()
    if has_telescope then
      tele_builtin.lsp_dynamic_workspace_symbols {}
    else
      vim.lsp.buf.workspace_symbol()
    end
  end, "Workspace Symbols")

  nmap("<leader>ll", function()
    vim.lsp.codelens.run()
  end, "CodeLens Action")
  nmap("<leader>la", function()
    vim.lsp.buf.code_action()
  end, "Code Action")
  nmap("<leader>lI", function()
    vim.cmd.LspInfo {}
  end, "Lsp Info")
  nmap("<leader>lL", function()
    vim.cmd.LspLog {}
  end, "Lsp Log")
  nmap("<leader>r", function()
    vim.lsp.buf.rename()
  end, "Rename")
  nmap("<leader>lq", function()
    vim.diagnostic.setloclist()
  end, "Lsp QFDiagnostics")
  -- Diagnostics
  nmap("]d", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostic")
  nmap("[d", function()
    vim.diagnostic.goto_prev()
  end, "Prev Diagnostic")
  nmap("<leader>dj", function()
    vim.diagnostic.goto_next()
  end, "Next Diagnostic")
  nmap("<leader>dk", function()
    vim.diagnostic.goto_prev()
  end, "Prev Diagnostic")


  -- useful keymaps for java
  nmap("<leader>oi", function() jdtls.organize_imports() end, "Organize Imports")
  nvmap("crv", function() jdtls.extract_variable(true) end, "Extract variable")
  nvmap("crc", function() jdtls.extract_constant(true) end, "Extract constant")
  vmap("crm", function() jdtls.extract_method(true) end, "Extract method")

  -- nvim-dap keymaps
  nmap("<leader>df", function() jdtls.test_class() end, "Test class")
  nmap("<leader>dn", function() jdtls.test_nearest_method() end, "Test near method")

  -- standard lsp keymaps (added because nvim-jdlts do not call LspAttach event for set keymaps)
  nmap("gl", function() vim.diagnostic.open_float() end, "Open float")
  nmap("K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, "Hover | PeekFold")

  vim.api.nvim_buf_create_user_command(bufnr, "JdtUpdateConfig", function()
    jdtls.update_project_config()
  end, { desc = "Jdtls config update", bang = true })

  vim.api.nvim_buf_create_user_command(bufnr, "JdtJol", function()
    jdtls.jol()
  end, { desc = "Memory usage", bang = true })

  vim.api.nvim_buf_create_user_command(bufnr, "JdtBytecode", function()
    jdtls.javap()
  end, { desc = "Show bytecode", bang = true })

  vim.api.nvim_buf_create_user_command(bufnr, "JdtJshell", function()
    jdtls.jshell()
  end, { desc = "Jshell", bang = true })
end


local function set_capabilities(client, bufnr)
  if vim.lsp.inlay_hint then
    vim.api.nvim_create_user_command("InlayHints", function()
      vim.lsp.inlay_hint(bufnr)
    end, { desc = "Toggle Inlay hints" })
  end

  -- lsp-document_highlight
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      -- group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      -- group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- Formatting
  if client.server_capabilities.documentFormattingProvider then
    local user_lib_format = require "lib.format"
    vim.api.nvim_create_user_command("LspAutoFormat", function()
      user_lib_format.toggle_format_on_save()
    end, {})

    vim.api.nvim_create_user_command("Format", function()
      user_lib_format.lsp_format(bufnr)
    end, { force = true })

    vim.keymap.set("n", "<leader>lf", function()
      user_lib_format.lsp_format(bufnr)
    end, { desc = "Format" })
    vim.keymap.set("n", "<leader>lF", function()
      vim.cmd.LspToggleAutoFormat()
    end, { desc = "Toggle AutoFormat" })
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("v", "<leader>lf", function()
      require("lib.utils").range_format()
    end, { desc = "Range format" })
  end

  vim.api.nvim_create_user_command("LspCapabilities", function()
    require("lib.utils").get_current_buf_lsp_capabilities()
  end, {})
end


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
    (vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/config_") .. os_name,
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
      filteredTypes = {
        "com.sun.*",
        "io.micrometer.shaded.*",
        "java.awt.*",
        "jdk.*", "sun.*",
      },
    },
    codeGeneration = {
      generateComments = true,
      toString = {
        template =
        "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      hashCodeEquals = {
        useJava7Objects = true
      },
      useBlocks = true,
    },
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
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
    },
  },
  handlers = { -- ovverride to mute
    ["language/status"] = function() end,
    -- ["textDocument/codeAction"] = function() end,
    -- ["textDocument/rename"] = function() end,
    -- ["workspace/applyEdit"] = function() end,
    ["textDocument/documentHighlight"] = function() end,
  },
  on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require "jdtls.dap".setup_dap_main_class_configs()

    set_keymaps(client, bufnr)
    set_capabilities(client, bufnr)
  end
}

require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
  -- -- UI
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

jdtls.start_or_attach(config)

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