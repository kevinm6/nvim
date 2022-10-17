-----------------------------------
--  File         : dap.lua
--  Description  : dap plugin config
--  Author       : Kevin
--  Last Modified: 16 Oct 2022, 21:09
-----------------------------------

local has_dap, dap = pcall(require, "dap")
if not has_dap then return end


-- TODO: add other config for useful filetypes

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
  command = "/usr/local/bin/kitty",
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


-- JAVA
-- dap.adapters.java = function(callback)
--  require("jdtls.util").execute_command({command = 'vscode.java.startDebugSession'}, function(err0, port)
--     assert(not err0, vim.inspect(err0))
--     -- print("jdtls:", port)
--     callback({
--       type = "server";
--       host = "127.0.0.1";
--       port = port;
--     })
--   end)
-- end

-- dap.configurations.java = {
--   type = "java",
--   request = "attach",
--   projectName = os.getenv("PROJECT_NAME") or nil,
--   name = "Debug (Attach) - Remote",
--   hostName = "127.0.0.1",
--   port = function()
--     require("jdtls.util").execute_command({command = 'vscode.java.startDebugSession'}, function(err0, port)
--       assert(not err0, "dap.java: ".. err0)
--       return port
--     end)
--   end
-- }


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
  command = os.getenv('HOME') .. '/.local/share/nvim/dap/python';
  args = { '-m', 'debugpy.adapter' };
}


-- GO
dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle, pid_or_err
  local port = 38697

  handle, pid_or_err = vim.loop.spawn("dlv", {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }, function(code)
    stdout:close()
    handle:close()

    print("[delve] Exit Code:", code)
  end)

  assert(handle, "Error running dlv: " .. tostring(pid_or_err))

  stdout:read_start(function(err, chunk)
    assert(not err, err)

    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
        print("[delve]", chunk)
      end)
    end
  end)

  -- Wait for delve to start
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  end, 100)
end

dap.configurations.go = {
  {
    type = "go",
    name = "Debug (from vscode-go)",
    request = "launch",
    showLog = false,
    program = "${file}",
    dlvToolPath = vim.fn.exepath "dlv", -- Adjust to where delve is installed
  },
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
    showLog = true,
    -- console = "externalTerminal",
    -- dlvToolPath = vim.fn.exepath "dlv",
  },
  {
    name = "Test Current File",
    type = "go",
    request = "launch",
    showLog = true,
    mode = "test",
    program = ".",
    dlvToolPath = vim.fn.exepath "dlv",
  },
}

local icons = require "user.icons"
local has_dapui, dapui = pcall(require, "dapui")
if not has_dapui then return end

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


