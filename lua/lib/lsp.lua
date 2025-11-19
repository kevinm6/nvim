-------------------------------------
--  File         : lsp.lua
--  Description  : lsp utility functions
--  Author       : Kevin
--  Last Modified: 29 Nov 2025, 17:26
-------------------------------------

local M = {}

---Completion for client
---@param arg string argument
---@return table
local complete_client = function(arg)
  return vim
      .iter(vim.lsp.get_clients())
      :map(function(client)
        return client.name
      end)
      :filter(function(name)
        return name:sub(1, #arg) == arg
      end)
      :totable()
end

---Completion for config
---@param arg string
---@return table
local complete_config = function(arg)
  return vim
      .iter(vim.api.nvim_get_runtime_file(('lsp/%s*.lua'):format(arg), true))
      :map(function(path)
        local file_name = path:match('[^/]*.lua$')
        return file_name:sub(0, #file_name - 4)
      end)
      :totable()
end

---Get current buf lsp Capabilities
---@see nvim_lsp_get_active_clients |nvim_lsp_get_active_clients()|
function M.get_current_buf_lsp_capabilities(client, _)
  local capAsList = {}
  for key, value in pairs(client.server_capabilities) do
    if value and key:find "Provider" then
      local capability = key:gsub("Provider$", "")
      table.insert(capAsList, "- " .. capability)
    end
  end
  table.sort(capAsList) -- sorts alphabetically
  local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
  vim.notify(msg, vim.log.levels.INFO, {
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
    end,
    timeout = 14000,
  })
  vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
end

---Enable|Disable Diagnostics
---@param buf number int id of buffer
function M.toggle_diagnostics(buf)
  vim.diagnostic.enable(not vim.diagnostic.is_enabled { bufnr = buf }, { bufnr = buf })
end

--- Set buffer keymaps on supported capabilities of the passed client and buffer id
--- @param client table client passed to attach config
--- @param bufnr integer client passed to attach config
function M.set_buf_keymaps(client, bufnr)
  local lsp = vim.lsp

  local _, snacks = pcall(require, "snacks.picker")

  local map = require("lib.keys").map

  -- Global Diagnostics keymaps
  map { "n", "gl", function() vim.diagnostic.open_float() end, { buffer = bufnr, desc = "Open Float" } }
  map {
    "n",
    "<leader>ld",
    function()
      local has_snacks, picker = pcall(require, "snacks.picker")
      if has_snacks then
        picker.diagnostics()
      else
        vim.diagnostic.setloclist()
      end
    end, { buffer = bufnr, desc = "QF Diagnostics" },
  }

  map {
    "n",
    "K",
    function()
      local has_ufo, ufo = pcall(require, "ufo")
      local winid = has_ufo and ufo.peekFoldedLinesUnderCursor() or false
      if winid then
        local buf = vim.api.nvim_win_get_buf(winid)
        vim.wo[winid].list = false
        local keys = { "a", "i", "o", "A", "I", "O", "gd", "gr" }
        for _, k in ipairs(keys) do
          vim.keymap.set("n", k, "<CR>" .. k, { noremap = false, buffer = buf })
        end
      else
        ---Hover
        lsp.buf.hover {
          title = "LSP❭ Hover",
          border = "rounded",
          max_height = math.floor(vim.o.lines * 0.6),
          max_width = math.floor(vim.o.columns * 0.8),
          wrap_at = math.floor(vim.o.columns * 0.8),
        }
      end
    end,
    { desc = "Hover | PeekFold", buffer = bufnr },
  }

  -- nmap { "grn", lsp.buf.rename, "rename" }
  -- if client:supports_method "textDocument/declaration" then
  --   nmap { "gD", lsp.buf.declaration, "GoTo Declaration" }
  -- end
  -- nmap {
  --   "gd",
  --   snacks.lsp_definitions or lsp.buf.definition,
  --   "GoTo Definitions",
  -- }

  if client:supports_method "textDocument/implementation" then
    map { "n", "gri", snacks.lsp_implementations or lsp.buf.incoming_calls, { buffer = bufnr, desc = "incoming-Calls" } }
  end

  if client:supports_method "callHierarchy/incomingCalls" then
    map { "n", "<leader>li", lsp.buf.incoming_calls, { buffer = bufnr, desc = "incoming-Calls" } }
  end

  if client:supports_method "textDocument/signatureHelp" then
    ---SignatureHelp
    map { { "s", "i" }, "<C-s>", function()
      lsp.buf.signature_help {
        title = "LSP❭ SignatureHelp",
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.6),
        max_height = math.floor(vim.o.lines * 0.4),
        close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
      }
    end, {
      buffer = bufnr,
      desc = "Lsp❭ SignatureHelp",
    } }
  end

  if client:supports_method "callHierarchy/outgoingCalls" then
    map { "n", "<leader>lo", lsp.buf.outgoing_calls, { buffer = bufnr, desc = "Outgoing-Calls" } }
  end
  ---References
  map {
    "n",
    "grr",
    snacks.lsp_references or lsp.buf.references { includeDeclaration = false, loclist = true },
    { buffer = bufnr, desc = "GoTo References" },
  }

  map {
    "n",
    "<leader>lt",
    snacks.lsp_type_definitions or lsp.buf.type_definition,
    { buffer = bufnr, desc = "TypeDef" },
  }

  map {
    "n",
    "gro",
    snacks.lsp_symbols or lsp.buf.document_symbol,
    { buffer = bufnr, desc = "Workspace Symbols" },
  }

  map {
    "n",
    "<leader>lws",
    snacks.lsp_workspace_symbols or lsp.buf.workspace_symbol,
    { buffer = bufnr, desc = "Workspace Symbols" },
  }
  if client:supports_method "workspace/workspaceFolders" then
    map { "n", "<leader>lwa", lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "Workspace Add Folder" } }
    map {
      "n",
      "<leader>lwr",
      lsp.buf.remove_workspace_folder,
      { buffer = bufnr, desc = "Workspace Remove Folder" },
    }

    map {
      "n",
      "<leader>lwl",
      function()
        print(table.concat(lsp.buf.list_workspace_folders(), "\n"))
      end,
      { buffer = bufnr, desc = "Workspace List Folders" },
    }
  end

  map { "n", "<leader>ll", lsp.codelens.run, { buffer = bufnr, desc = "CodeLens" } }
end

--- Set buffer capabilities if supported by the passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr integer buffer id passed to attach config
function M.set_buf_funcs_for_capabilities(client, bufnr)
  local lsp = vim.lsp
  local autocmd = vim.api.nvim_create_autocmd
  local usercmd = vim.api.nvim_create_user_command

  -- Completion
  -- NOTE nvim-0.11: still not useful for me, doesn't supports custom snippets
  -- if client.supports_method "textDocument/completion" then
  -- trigger autocompletion on EVERY keypress. May be slow!
  -- local chars = {}
  -- for i = 32, 126 do
  --   table.insert(chars, string.char(i))
  -- end
  -- client.server_capabilities.completionProvider.triggerCharacters = chars
  --   lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  -- end

  -- InlayHints
  if client:supports_method "textDocument/inlayHint" then
    usercmd("ToggleInlayHints", function()
      lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { desc = "Toggle Inlay hints" })
  end

  -- lsp-document_highlight
  if client:supports_method "textDocument/documentHighlight" then
    local _lsp_hi_group = vim.api.nvim_create_augroup("_lsp_highlight_group", { clear = true })
    autocmd({ "CursorHold", "CursorHoldI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = function()
        return lsp.buf.document_highlight()
      end,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = lsp.buf.clear_references,
    })

    autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
      callback = lsp.buf.clear_references
      -- vim.api.nvim_clear_autocmds { group = _lsp_hi_group, buffer = bufnr }
    })
  end

  usercmd("LspCapabilities", function()
    require("lib.lsp").get_current_buf_lsp_capabilities(client, bufnr)
  end, { desc = "List server capabilities" })

  usercmd("ToggleDiagnostics", function()
    require("lib.lsp").toggle_diagnostics(bufnr)
  end, { desc = "List server capabilities" })

  usercmd("LspStart", function(info)
    if vim.lsp.config[info.args] == nil then
      vim.notify(("Invalid server name '%s'"):format(info.args))
      return
    end

    vim.lsp.enable(info.args)
  end, {
    desc = 'Enable and launch a language server',
    nargs = '?',
    complete = complete_config,
  })

  usercmd("LspRestart", function(info)
    for _, name in ipairs(info.fargs) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(info.args))
      else
        vim.lsp.enable(name, false)
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for _, name in ipairs(info.fargs) do
        vim.schedule_wrap(function(x)
          vim.lsp.enable(x)
        end)(name)
      end
    end)
  end, {
    desc = 'Restart the given client(s)',
    nargs = '+',
    complete = complete_client,
  })

  usercmd("LspStop", function(info)
    for _, name in ipairs(info.fargs) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(info.args))
      else
        vim.lsp.enable(name, false)
      end
    end
  end, {
    desc = 'Disable and stop the given client(s)',
    nargs = '+',
    complete = complete_client,
  })

  -- Enable completion on <c-x><c-o>
  -- vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

return M