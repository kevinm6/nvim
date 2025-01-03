-------------------------------------
-- File         : java.lua
-- Description  : java language server configuration (jdtls)
-- Author       : Kevin
-- Last Modified: 07 May 2024, 17:02
-------------------------------------

local has_jdtls, jdtls = pcall(require, "jdtls")
if not has_jdtls then
  vim.notify(" ERROR loading jdtls", vim.log.levels.ERROR)
  return
end

local data_path = vim.fn.stdpath "data"

local capabilities = require("plugins.lsp").capabilities()
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.document_formatting = false

local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" })
  or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
local cache_dir = vim.fn.stdpath "cache"
local project_name = vim.fs.basename(root_dir or vim.uv.cwd())
local workspace_dir = string.format("%s/java/wksp/%s", cache_dir, project_name)

local launcher_path = vim.fn.glob(data_path .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar", true)
local bundles = vim.fn.glob(
  data_path .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  true,
  true
)

-- Example usage: Run the function with the desired task
-- RunGradleTask('test')

local lombok_path = data_path .. "/mason/packages/jdtls/lombok.jar"

local function get_config_dir()
  local os_uname, sys_config = vim.uv.os_uname(), nil
  if os_uname.sysname == "Darwin" then
    if os_uname.machine == "arm64" then
      sys_config = "mac_arm"
    else
      sys_config = "mac"
    end
  elseif os_uname.sysname == "Linux" then
    sys_config = "linux"
  else
    sys_config = "win"
  end

  return string.format("%s/mason/packages/jdtls/config_%s", vim.fn.stdpath "data", sys_config)
end

vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(data_path .. "/mason/packages/java-test/extension/server/*.jar", true), "\n")
)

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
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    launcher_path,

    "-javaagent",
    lombok_path,
    "-Xbootclasspath/a",
    lombok_path,

    "-configuration",
    get_config_dir(),
    "-data",
    workspace_dir,
  },
  capabilities = capabilities,
  -- root_dir = root_dir,
  single_file_support = true,
  settings = {
    java = {
      redhat = {
        telemetry = { enabled = false },
      },
      autobuild = { enabled = false },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      saveActions = {
        organizeImports = true,
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      import = {
        gradle = {
          enabled = true,
        },
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
          },
          {
            name = "JavaSE-21",
            path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
          },
        },
      },
      testsCodeLens = {
        enabled = true,
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
  on_init = function(client)
    require("plugins.lsp").on_init(client)
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end,
  init_options = {
    -- jvm_args = "-javaagent:" .. vim.fn.expand "~/.local/share/nvim/mason/packages/jdtls/lombok.jar",
    -- workspace = workspace_dir .. project_name,
    -- capabilities = capabilities,
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
    codelenses = {
      test = true,
    },
    dynamicRegistration = true,
  },
  handlers = { -- ovverride to mute
    ["language/status"] = function() end,
  },
  on_attach = function(client, bufnr)
    jdtls.setup_dap { config_overrides = {}, hotcodereplace = "auto" }
    vim.schedule(function()
      require("jdtls.dap").setup_dap_main_class_configs {}
    end)

    require("plugins.lsp").on_attach(client, bufnr)

    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        client.request_sync("java/buildWorkspace", false, 5000, bufnr)
      end,
    })
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
        jdtls.pick_test()
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
  end,
}

jdtls.start_or_attach(config)

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

if vim.fn.filereadable(root_dir .. "/gradlew") then
  local gradlew = root_dir .. "/gradlew"

  local function get_gradle_tasks()
    if vim.g["gradle_" .. root_dir] ~= nil then
      return vim.g["gradle_" .. root_dir]
    end

    local taskList = {}
    local out = vim.system({ gradlew, "tasks", "--all" }, { text = true }):wait()
    if out.code == 0 then
      for line in out.stdout:gmatch "[^\r\n]+" do
        if line:find " - " then
          local taskName = line:match "^(.-)%s+-" --line:match("^(.-) -")
          if taskName then
            table.insert(taskList, taskName)
          end
        end
      end
      vim.g["gradle_" .. root_dir] = taskList
    else
      vim.notify("Error executing command: " .. out.stderr, vim.log.levels.ERROR, { text = "Gradle (tasks)" })
    end
    return taskList
  end

  local function select_gradle_task(tasks, callback)
    vim.ui.select(tasks, {
      prompt = "⟩ Gradle task: ",
    }, function(choice)
      if not choice then
        return
      end
      callback(choice)
    end)
  end

  local function run_gradle_task(task)
    local msg = string.format(" running: < gradlew %s >", task)
    vim.notify(msg, vim.log.levels.INFO, { title = "Gradle" })
    vim.system({ gradlew, task }, { text = true }, function(obj)
      if obj.code ~= 0 then
        vim.notify(obj.stderr, vim.log.levels.WARN)
      else
        vim.print(obj.stdout)
        vim.schedule(function()
          vim.fn.setqflist({}, "r", { title = "Gradle Output", lines = vim.split(obj.stdout, "\n") })
          vim.cmd.copen()
        end)
      end
    end)
  end

  vim.api.nvim_create_user_command("Gradle", function(input)
    local task = nil
    if input.args ~= "" then
      run_gradle_task(task)
    else
      local tasks = get_gradle_tasks()
      select_gradle_task(tasks, function(selected_task)
        run_gradle_task(selected_task)
      end)
    end
  end, {
    nargs = "?",
    complete = get_gradle_tasks,
  })
end
