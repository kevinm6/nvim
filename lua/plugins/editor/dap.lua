-----------------------------------
--  File         : dap.lua
--  Description  : dap plugin config
--  Author       : Kevin
--  Last Modified: 17 Nov 2024, 10:49
-----------------------------------

return {
  -- "theHamsta/nvim-dap-virtual-text",
  ---DAP-UI
  "nvim-neotest/nvim-nio",
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      icons = { expanded = "▾", collapsed = "►" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },

      layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 0.2,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },

      floating = {
        max_height = nil,
        max_width = nil,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },

      windows = { indent = 1 },
      -- vim.keymap.set("n", "<leader>de", function() end)
    },
  },
  ---DAP
  {
    "mfussenegger/nvim-dap",
    event = { "BufRead", "BufNewFile" },
    keys = { { "<leader>d", desc = "DAP" } },
    config = function()
      local dap = require "dap"

      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/env kitty",
        args = { "--hold", "-e" },
      }

      -- Filetype configs
      -- C
      dap.adapters.c = {
        name = "lldb",
        type = "executable",
        command = "/usr/bin/lldb",
        attach = {
          pidProperty = "pid",
          pidSelect = "ask",
        },
        env = {
          LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
        },
      }

      -- CPP
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.uv.cwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          postRunCommands = { "process handle -p true -s false -n false SIGWINCH" },
        },
      }

      -- C
      dap.configurations.c = dap.configurations.cpp

      -- RUST
      dap.configurations.rust = dap.configurations.cpp

      -- LUA
      dap.configurations.lua = {
        {
          name = "Current file (local-lua-dbg, nlua)",
          type = "local-lua",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = {
            lua = vim.env.HOME .. "/.luarocks/bin/nlua",
            file = "${file}",
          },
          verbose = true,
          args = {},
        },
      }

      -- PYTHON
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath "data" .. "/.venv/bin/python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Build api",
          program = "${file}",
          args = { "--target", "api" },
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "lsif",
          program = "src/lsif/__main__.py",
          args = {},
          console = "integratedTerminal",
        },
      }

      -- GO
      dap.adapters.go = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath "data" .. "/mason/packages/go-debug-adapter/extension/dist/debugAdapter.js" },
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          showLog = false,
          program = "${file}",
          dlvToolPath = vim.fn.exepath "dlv",
        },
        {
          type = "go",
          name = "Debug (test file)",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = function()
            require("dap.utils").pick_file { filter = ".*%test.go", executables = false }
          end,
          console = "integratedTerminal",
          dlvToolPath = vim.fn.exepath "dlv",
          mode = "test",
          showLog = true,
          showRegisters = true,
          stopOnEntry = false,
        },
        {
          type = "go",
          name = "Debug (using go.mod)",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = "./${relativeFileDirname}",
          console = "integratedTerminal",
          dlvToolPath = vim.fn.exepath "dlv",
          mode = "test",
          -- showLog = true,
          -- showRegisters = true,
          stopOnEntry = false,
        },
      }

      -- Javascript / Typescript (firefox)
      local js_based_languages = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
      }

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      for _, lang in pairs(js_based_languages) do
        dap.configurations[lang] = {
          { -- single nodejs file
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = "node",
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**",
            },
          },
          { -- debug nodejs process (need --inspect flag to get the processId)
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = {
              "<node_internals>/**",
              "node_modules/**",
            },
          },
          {
            type = "node-terminal",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**/*.js" },
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          {
            name = "---- ↓ launch.json configs ↓ ----",
            type = "",
            request = "launch",
          },
        }
      end

      -- dap.adapters.firefox = {
      --   type = "executable",
      --   command = vim.fn.stdpath "data" .. "/mason/bin/firefox-debug-adapter",
      -- }
      -- dap.configurations.typescript = {
      --   {
      --     name = "Debug with Firefox",
      --     type = "firefox",
      --     request = "launch",
      --     reAttach = true,
      --     url = "http://localhost:4200", -- Write the actual URL of your project.
      --     webRoot = "${workspaceFolder}",
      --     firefoxExecutable = vim.fn.expand "$HOMEBREW_DIR" .. "/firefox",
      --   },
      -- }

      -- PHP
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath "data" .. "~/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
        },
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9000,
        },
      }

      -- Bash
      dap.adapters.bashdb = {
        type = "executable",
        command = vim.fn.stdpath "data" .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
      }

      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath "data" .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = vim.fn.stdpath "data" .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/opt/homebrew/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }

      -- Gradle
      -- dap.adapters.gradle = {
      --   name = "gradle",
      --   type = "executable",
      --   command = vim.fn.exepath "gradle",
      --   -- cwd = "${workspaceFolder}",
      -- }

      -- dap.configurations.java = {
      --   {
      --     name = "Gradle tasks",
      --     request = "launch",
      --     type = "gradle",
      --     program = "${workspaceFolder}/gradlew",
      --     cwd = "${workspaceFolder}",
      --     args = { "${input:gradleCmd}" },
      --   },
      --   -- inputs = {
      --   --   {
      --   --     id = "gradleCmd",
      --   --     type = "promptString",
      --   --     description = "Program to run: ",
      --   --     default = "test",
      --   --   },
      --   -- },
      -- }

      local icons = require "mini.icons"

      vim.fn.sign_define("DapBreakpoint", {
        text = icons.get("file", "breakpoint"),
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      local dapui = require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      -- set keymaps
      local function map(tbl)
        vim.keymap.set(tbl.mode or "n", tbl[1], tbl[2], { desc = "DAP❭ " .. tbl[3] })
      end

      map { "<localleader>db", dap.toggle_breakpoint, "Breakpoint" }
      map {
        "<localleader>dB",
        function()
          dap.set_breakpoint(vim.fn.input(icons.get("file", "breakpoint") .. " Breakpoint condition: "))
        end,
        "Breakpoint cond",
      }
      -- nmap { "<leader>dc", require "dap".continue(), "Run Debug"
      map { "<localleader>di", dap.step_into, "Into" }
      map { "<localleader>do", dap.step_over, "Over" }
      map { "<F9>", dap.step_over, "Over" }
      map { "<localleader>dO", dap.step_out, "Out" }
      map { "<localleader>dr", dap.repl.toggle, "Repl" }
      map { "<localleader>dl", dap.run_last, "Last" }
      map { "<localleader>du", require("dapui").toggle, "UI" }
      map { "<localleader>dx", dap.terminate, "Exit" }
      map { "<localleader>dc", dap.continue, "Run Debug" }
      map { "<F8>", dap.continue, "Run Debug" }

      map {
        mode = { "v", "x" },
        "K",
        function()
          dapui.eval()
        end,
        "Eval",
      }

      map {
        "<localleader>dC",
        function()
          package.loaded["plugins.editor.dap"] = nil
          require "plugins.editor.dap"
          dap.continue()
        end,
        "Reload ∧ Continue",
      }

      -- map <localleader>{k,K} dap.hover & dapui.eval
      local api = vim.api
      local keymap_restore = {}
      dap.listeners.after["event_initialized"]["me"] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
          local keymaps = api.nvim_buf_get_keymap(buf, "n")
          for _, keymap in pairs(keymaps) do
            if keymap.lhs == "<localleader>K" then
              table.insert(keymap_restore, keymap)
              vim.keymap.del("n", "<localleader>k", { buffer = buf })
            end
          end
        end
        vim.keymap.set("n", "<localleader>k", function()
          require("dap.ui.widgets").hover()
        end, { desc = "DAP•Hover", silent = true })
        vim.keymap.set("n", "<localleader>K", function()
          dapui.eval()
        end, { desc = "DAP•eval", silent = true })
      end

      dap.listeners.after["event_terminated"]["me"] = function()
        for _, keymap in pairs(keymap_restore) do
          vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
        end
        keymap_restore = {}
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          require("dap.ext.autocompl").attach()
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local dap_py_venv = vim.fn.stdpath("data").."/mason/packages/debugpy/venv/bin/python3.12"
      require "dap-python".setup(dap_py_venv)
    end
  },
}