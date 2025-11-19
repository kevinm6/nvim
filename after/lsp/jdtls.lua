local data_path = vim.fn.stdpath "data"
local bundles = vim.fn.glob(
  data_path .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  true,
  true
)
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(data_path .. "/mason/packages/java-test/extension/server/*.jar", true), "\n")
)

---@type vim.lsp.Config
return {
  before_init = function(params)
    params.initializationOptions.bundles = bundles
  end,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
    resolveAdditionalTextEditsSupport = true,
    document_formatting = false
  },
  -- root_dir = root_dir,
  single_file_support = true,
  settings = {
    java = {
      redhat = { telemetry = { enabled = false } },
      autobuild = { enabled = false },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      -- contentProvider = { preferred = "fernflower" },
      saveActions = { organizeImports = false },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      import = { gradle = { enabled = true } },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          -- {
          --   name = "JavaSE-17",
          --   path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
          -- },
          {
            name = "JavaSE-21",
            path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
          },
          -- {
          --   name = "JavaSE-24",
          --   path = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
          -- },
          {
            name = "JavaSE-25",
            path = "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home",
          },
        },
      },
      testsCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      format = {
        enabled = true,
        settings = {
          ["org.eclipse.jdt.core.formatter.comment.line_length"] = 100,
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
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      codeGeneration = {
        generateComments = true,
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = { useJava7Objects = true },
        useBlocks = true,
      },
      flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
      },
    },
  },
  -- on_init = function(client)
  --   client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  -- end,
  init_options = {
    bundles = bundles,
    codelenses = { test = true },
    dynamicRegistration = true,
  },
  handlers = { -- ovverride to mute
    ["language/status"] = function() end,
  },
  on_attach = function(client, bufnr)
    local has_jdtls, jdtls = pcall(require, "jdtls")
    if has_jdtls then
      jdtls.setup_dap { config_overrides = {}, hotcodereplace = "auto" }
      vim.schedule(function()
        require("jdtls.dap").setup_dap_main_class_configs {}

        local _, dap = pcall(require, "dap")
        local old_dap_function = dap.adapters.java
        dap.adapters.java = function(callback, configDap)
          if configDap.name == "Nearest Method" then
            jdtls.test_nearest_method()
          elseif configDap.name == "Test Class" then
            jdtls.test_class()
          else
            old_dap_function(callback, configDap)
          end
        end

        dap.configurations.java = {
          {
            type = 'java',
            request = 'launch',
            name = "Nearest Method",
          },
          {
            type = 'java',
            request = 'launch',
            name = "Test Class",
          }
        }
      end)
    end
    require("lib.lsp").set_buf_funcs_for_capabilities(client, bufnr)
    require("lib.lsp").set_buf_keymaps(client, bufnr)

    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        ---@diagnostic disable-next-line: param-type-mismatch
        client:request_sync("java/buildWorkspace", false, 5000, bufnr)
      end,
    })

    if not has_jdtls then return end
    local function map(tbl)
      vim.keymap.set(tbl[1], tbl[2], tbl[3], { buffer = bufnr, desc = "Java❭ " .. tbl[4] })
    end

    map {
      "n",
      "<localleader>oi",
      function()
        jdtls.organize_imports()
      end,
      "Organize Imports",
    }
    map {
      { "n", "v" },
      "crv",
      function()
        jdtls.extract_variable()
      end,
      "Extract Variable",
    }
    map {
      { "n", "v" },
      "crc",
      function()
        jdtls.extract_constant()
      end,
      "Extract Constant",
    }
    map {
      "v",
      "crm",
      function()
        jdtls.extract_method { visual = true }
      end,
      "Extract Method",
    }

    -- nvim-dap keymaps
    map {
      "n",
      "<localleader>df",
      function()
        jdtls.test_class()
      end,
      "Test Class",
    }
    map {
      "n",
      "<localleader>dp",
      function()
        local dap = require("dap")
        if dap.session() then
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        else
          ---@diagnostic disable-next-line: param-type-mismatch
          client:request_sync("java/buildWorkspace", false, 5000, bufnr)
          require("jdtls.dap").pick_test()
        end
      end,
      "Pick Test",
    }
    map {
      "n",
      "<localleader>dn",
      function()
        jdtls.test_nearest_method {
          config = { console = "console" },
        }
      end,
      "Test Near method",
    }
    map {
      "n",
      "<localleader>dtg",
      function()
        require("jdtls.tests").generate()
      end,
      "GoTo Test generate",
    }
    map {
      "n",
      "<localleader>dts",
      function()
        require("jdtls.tests").goto_subjects()
      end,
      "GoTo Test subjects",
    }
  end,
}