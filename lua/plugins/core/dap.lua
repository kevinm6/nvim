-----------------------------------
--  File         : dap.lua
--  Description  : dap plugin config
--  Author       : Kevin
--  Last Modified: 28 May 2023, 13:20
-----------------------------------

local M = {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>dp", function() require "dap".toggle_breakpoint() end, desc = "Breakpoint" },
    { "<leader>dc", function() require "dap".continue() end, desc = "Continue" },
    { "<leader>di", function() require "dap".step_into() end, desc = "Into" },
    { "<leader>do", function() require "dap".step_over() end, desc = "Over" },
    { "<leader>dO", function() require "dap".step_out() end, desc = "Out" },
    { "<leader>dr", function() require "dap".repl.toggle() end, desc = "Repl" },
    { "<leader>dl", function() require "dap".run_last() end, desc = "Last" },
    { "<leader>du", function() require "dapui".toggle {} end, desc = "UI" },
    { "<leader>dx", function() require "dap".terminate() end, desc = "Exit" },

  }
}

function M.config()
  local dap = require "dap"

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
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},

      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:

      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

      -- Otherwise you might get the following error:

      --    Error on launch: Failed to attach to the target process

      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html

      runInTerminal = false,

      -- 💀
      -- If you use `runInTerminal = true` and resize the terminal window,
      -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
      -- To avoid that uncomment the following option
      -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
      postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
    },
  }

  dap.defaults.fallback.external_terminal = {
    command = "/usr/bin/env kitty",
    args = { "-e " },
  }

  -- C
  dap.configurations.c = dap.configurations.cpp


  -- RUST
  dap.configurations.rust = dap.configurations.cpp



  -- LUA
  dap.adapters.nlua = function(callback, config)
   callback {
      type = "server",
      host = config.host,
      port = config.port
    }
  end

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = "127.0.0.1",
      port = function()
        -- local val = tonumber(vim.fn.input('Port: '))
        -- assert(val, "Please provide a port number")
        local p = 54231
        return p
      end,
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
    type = 'executable';
    command = vim.fn.stdpath "data" .. "/dap/python",
    args = { '-m', 'debugpy.adapter' },
  }


  -- GO
   dap.adapters.go = {
     type = 'executable';
     command = 'node';
     args = { vim.fn.stdpath "data" .. "/mason/packages/go-debug-adapter/extension/dist/debugAdapter.js" }
   }
   dap.configurations.go = {
     {
       type = 'go';
       name = 'Debug';
       request = 'launch';
       showLog = false;
       program = "${file}";
       dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
     },
   }


   -- JavaScript
   dap.adapters["pwa-node"] = {
     type = "server",
     host = "localhost",
     port = "${port}",
     executable = {
       command = "node",
       -- 💀 Make sure to update this path to point to your installation
       args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
     }
   }

   dap.configurations.javascript = {
     {
       type = "pwa-node",
       request = "launch",
       name = "Launch file",
       program = "${file}",
       cwd = "${workspaceFolder}",
     },
   }


   -- Bash
   dap.adapters.bashdb = {
     type = 'executable';
     command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
     name = 'bashdb';
   }

   dap.configurations.sh = {
     {
       type = 'bashdb';
       request = 'launch';
       name = "Launch file";
       showDebugOutput = true;
       pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
       pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
       trace = true;
       file = "${file}";
       program = "${file}";
       cwd = '${workspaceFolder}';
       pathCat = "cat";
       pathBash = "/opt/homebrew/bin/bash";
       pathMkfifo = "mkfifo";
       pathPkill = "pkill";
       args = {};
       env = {};
       terminalKind = "integrated";
     }
   }


  local icons = require "user_lib.icons"
  local has_dapui, dapui = pcall(require, "dapui")
  if has_dapui then
    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸" },
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
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "rounded", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
    }
  end


  vim.fn.sign_define('DapBreakpoint', {text=icons.ui.Bug, texthl='DiagnosticSignError', linehl='', numhl=''})

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  -- dap.listeners.before.event_terminated["dapui_config"] = function()
  --   dapui.close()
  -- end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end


end

return M
