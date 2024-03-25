-----------------------------------
--  File         : dap.lua
--  Description  : dap plugin config
--  Author       : Kevin
--  Last Modified: 30 Mar 2024, 17:17
-----------------------------------

local M = {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    opts = function(_, o)
      o.icons = { expanded = "▾", collapsed = "►" }
      o.mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      }

      o.layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "right",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      }

      o.floating = {
        max_height = nil,   -- These can be integers or a float between 0 and 1.
        max_width = nil,    -- Floats will be treated as percentage of your screen.
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      }

      o.windows = { indent = 1 }
    end
  },
  -- "theHamsta/nvim-dap-virtual-text",
  {
    "mfussenegger/nvim-dap",
    -- keys = {
    --   { "<leader>d", function() end, desc = "Dap" },
    -- },
    config = function()
      local dap = require "dap"

      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/env kitty",
        args = { "-e " },
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
            return vim.fn.input('Path to executable: ', vim.uv.cwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          postRunCommands = { 'process handle -p true -s false -n false SIGWINCH' }
        },
      }

      -- C
      dap.configurations.c = dap.configurations.cpp


      -- RUST
      dap.configurations.rust = dap.configurations.cpp


      -- LUA
      -- dap.adapters.nlua = function(callback, config)
      --   callback {
      --     type = "server",
      --     host = config.host,
      --     port = config.port
      --   }
      -- end

      dap.configurations.lua = {
        {
          name = 'Current file (local-lua-dbg, nlua)',
          type = 'local-lua',
          request = 'launch',
          cwd = '${workspaceFolder}',
          program = {
            lua = '~/.luarocks/bin/nlua',
            file = '${file}',
          },
          verbose = true,
          args = {},
        },
      }


      -- PYTHON
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

      dap.adapters.python = {
        type = 'executable',
        command = vim.fn.stdpath "data" .. "/nvim_python_venv/bin/python",
        args = { '-m', 'debugpy.adapter' },
      }


      -- GO
      dap.adapters.go = {
        type = 'executable',
        command = 'node',
        args = { vim.fn.stdpath "data" .. "/mason/packages/go-debug-adapter/extension/dist/debugAdapter.js" }
      }
      dap.configurations.go = {
        {
          type = 'go',
          name = 'Debug',
          request = 'launch',
          showLog = false,
          program = "${file}",
          dlvToolPath = vim.fn.exepath('dlv') -- Adjust to where delve is installed
        },
      }


      -- JavaScript
      local js_based_languages = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact"
      }

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        }
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
            runtimeExecutable = 'node',
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = {
              '<node_internals>/**',
              'node_modules/**',
            },
          },
          { -- debug nodejs process (need --inspect flag to get the processId)
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require "dap.utils".pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = {
              '<node_internals>/**',
              'node_modules/**',
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
                  default = "http://localhost:3000"
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end
                )
              end)
            end,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**/*.js" },
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false
          },
          {
            name = "---- ↓ launch.json configs ↓ ----",
            type = "",
            request = "launch"
          }
        }
      end

      -- Javascript / Typescript (firefox)
      dap.adapters.firefox = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/bin/firefox-debug-adapter',
      }
      dap.configurations.typescript = {
        {
          name = 'Debug with Firefox',
          type = 'firefox',
          request = 'launch',
          reAttach = true,
          url = 'http://localhost:4200', -- Write the actual URL of your project.
          webRoot = '${workspaceFolder}',
          firefoxExecutable = vim.fn.expand "$HOMEBREW_DIR" .. '/firefox'
        }
      }

      -- PHP
      dap.adapters.php = {
        type = 'executable',
        command = vim.fn.stdpath("data") .. '/mason/bin/php-debug-adapter',
      }
      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9000
        }
      }


      -- Bash
      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath("data") ..
            '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      }

      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath("data") ..
              '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath("data") ..
              '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = '${workspaceFolder}',
          pathCat = "cat",
          pathBash = "/opt/homebrew/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        }
      }


      vim.fn.sign_define('DapBreakpoint', {
        text = require("lib.icons").ui.Bug,
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = ''
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      dap.listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end

      -- set keymaps
      local function nmap(tbl)
        vim.keymap.set("n", tbl[1], tbl[2], { desc = "DAP • "..tbl[3] })
      end

      nmap { "<localleader>d", function() end, "" }
      nmap { "<localleader>db", dap.toggle_breakpoint, "Breakpoint" }
      -- nmap { "<leader>dc", require "dap".continue(), "Run Debug" }
      nmap { "<localleader>di", dap.step_into, "Into" }
      nmap { "<localleader>do", dap.step_over, "Over" }
      nmap { "<localleader>dO", dap.step_out, "Out" }
      nmap { "<localleader>dr", dap.repl.toggle, "Repl" }
      nmap { "<localleader>dl", dap.run_last, "Last" }
      nmap { "<localleader>du", require "dapui".toggle, "UI" }
      nmap { "<localleader>dx", dap.terminate, "Exit" }

      nmap { "<localleader>dc", function()
        if vim.fn.filereadable(".vscode/launch.json") == 1 then
          local dap_vscode = require "dap.ext.vscode"
          dap_vscode.load_launchjs(nil, {
            ["pwa-node"] = js_based_languages,
            ["node"] = js_based_languages,
            ["node-terminal"] = js_based_languages,
          })
        end
        dap.continue()
      end, "Run Debug [args]" }
    end
  }
}

return M