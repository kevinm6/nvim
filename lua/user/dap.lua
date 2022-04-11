-----------------------------------
--  File         : dap.lua
--  Description  : dap plugin config
--  Author       : Kevin
--  Source       : https://github.com/kevinm6/nvim/blob/nvim/lua/user/dap.lua
--  Last Modified: 10/04/2022 - 14:09
-----------------------------------

local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then return end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then return end

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
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
    {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
    { id = "breakpoints", size = 0.25 },
      -- { id = "stacks", size = 0.25 },
      -- { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "right", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = {},
    -- elements = { "repl" },
    -- size = 10,
    -- position = "bottom", -- Can be "left", "right", "top", "bottom"
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

local icons = require "user.icons"

vim.fn.sign_define('DapBreakpoint', {text=icons.ui.Bug, texthl='DiagnosticSignError', linehl='', numhl=''})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


-- Filetype configs
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb",
  name = "lldb"
}

local dap_install = require("dap-install")

dap_install.setup({
	installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})

-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "lldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html

--     runInTerminal = false,
--
--     -- 💀
--     -- If you use `runInTerminal = true` and resize the terminal window,
--     -- lldb-vscode will receive a `SIGWINCH` signal which can cause problems
--     -- To avoid that uncomment the following option
--     -- See https://github.com/mfussenegger/nvim-dap/issues/236#issuecomment-1066306073
--     postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
--   },
-- }

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp

-- TODO: add other config for useful filetypes
