-------------------------------------
--  File         : lsp.lua
--  Description  : lsp utility functions
--  Author       : Kevin
--  Last Modified: 26 Apr 2024, 20:22
-------------------------------------

local M = {}

local api, lsp = vim.api, vim.lsp
local autocmd = api.nvim_create_autocmd

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
  local _, snacks = pcall(require, "snacks.picker")

  local function nmap(tbl)
    vim.keymap.set("n", tbl[1], tbl[2], { buffer = bufnr, desc = "Lsp❭ " .. tbl[3] })
  end
  -- Global Diagnostics keymaps
  nmap { "gl", vim.diagnostic.open_float, "Open Float" }
  nmap {
    "<leader>ld",
    require("snacks.picker").diagnostics or vim.diagnostic.setloclist,
    "QF Diagnostics",
  }

  nmap {
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
    "Hover | PeekFold",
  }

  nmap { "grn", lsp.buf.rename, "rename" }
  if client.supports_method "textDocument/declaration" then
    nmap { "gD", lsp.buf.declaration, "GoTo Declaration" }
  end
  nmap {
    "gd",
    snacks.lsp_definitions or lsp.buf.definition,
    "GoTo Definitions",
  }

  if client.supports_method "textDocument/implementation" then
    nmap { "gri", snacks.lsp_implementations or lsp.buf.incoming_calls, "incoming-Calls" }
  end

  if client.supports_method "callHierarchy/incomingCalls" then
    nmap { "<leader>li", lsp.buf.incoming_calls, "incoming-Calls" }
  end

  if client.supports_method "textDocument/signatureHelp" then
    ---SignatureHelp
    vim.keymap.set("s", "<C-s>", function()
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
    })
  end

  if client.supports_method "callHierarchy/outgoingCalls" then
    nmap { "<leader>lo", lsp.buf.outgoing_calls, "Outgoing-Calls" }
  end
  ---References
  nmap {
    "grr",
    snacks.lsp_references or lsp.buf.references { includeDeclaration = false, loclist = true },
    "GoTo References",
  }

  nmap {
    "<leader>lt",
    snacks.lsp_type_definitions or lsp.buf.type_definition,
    "TypeDef",
  }

  nmap {
    "gO",
    snacks.lsp_symbols or lsp.buf.document_symbol,
    "Workspace Symbols",
  }

  nmap {
    "<leader>lws",
    snacks.lsp_workspace_symbols or lsp.buf.workspace_symbol,
    "Workspace Symbols",
  }
  if client.supports_method "workspace/workspaceFolders" then
    nmap { "<leader>lwa", lsp.buf.add_workspace_folder, "Workspace Add Folder" }
    nmap {
      "<leader>lwr",
      lsp.buf.remove_workspace_folder,
      "Workspace Remove Folder",
    }

    nmap {
      "<leader>lwl",
      function()
        print(table.concat(lsp.buf.list_workspace_folders(), "\n"))
      end,
      "Workspace List Folders",
    }
  end

  nmap { "<leader>la", lsp.buf.code_action, "Code Action" }

  nmap { "<leader>ll", lsp.codelens.run, "CodeLens" }
end

--- Set buffer capabilities if supported by the passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr integer buffer id passed to attach config
function M.set_buf_funcs_for_capabilities(client, bufnr)
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
  if client.supports_method "textDocument/inlayHint" then
    usercmd("ToggleInlayHints", function()
      lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { desc = "Toggle Inlay hints" })
  end

  -- lsp-document_highlight
  if client.supports_method "textDocument/documentHighlight" then
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
      callback = function()
        lsp.buf.clear_references()
        -- vim.api.nvim_clear_autocmds { group = _lsp_hi_group, buffer = bufnr }
      end,
    })
  end

  usercmd("LspCapabilities", function()
    require("lib.lsp").get_current_buf_lsp_capabilities(client, bufnr)
  end, { desc = "List server capabilities" })

  usercmd("ToggleDiagnostics", function()
    require("lib.lsp").toggle_diagnostics(bufnr)
  end, { desc = "List server capabilities" })

  -- Enable completion on <c-x><c-o>
  -- vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

return M