-------------------------------------
-- File         : lsp.lua
-- Description  : lsp config nvim-0.11
-- Author       : Kevin
-- Last Modified: 05 Apr 2025, 20:37
-------------------------------------

local api, lsp = vim.api, vim.lsp
local autocmd = api.nvim_create_autocmd

---Create capabilities and set default values
---default and `cmp_nvim_lsp`
---@return table capabilities custom capabilities merged with default
local function init_capabilities()
  -- Update capabilities with extended from cmp_nvim_lsp if available
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- local has_blink, blink = pcall(require, "blink.cmp")
  -- if has_blink then
  --   capabilities = blink.get_lsp_capabilities(capabilities)
  -- end
  -- Adding snippetSupport enabled by default for each LSP
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end

--- Set buffer keymaps on supported capabilities of the passed client and buffer id
--- @param client table client passed to attach config
--- @param bufnr integer client passed to attach config
local function set_buf_keymaps(client, bufnr)
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
        vim.lsp.buf.hover {
          title = "LSP❭ Hover",
          border = "rounded",
          max_height = math.floor(vim.o.lines * 0.6),
          max_width = math.floor(vim.o.columns * 0.8),
        }
      end
    end,
    "Hover | PeekFold",
  }

  nmap { "grn", vim.lsp.buf.rename, "rename" }
  if client.supports_method "textDocument/declaration" then
    nmap { "gD", vim.lsp.buf.declaration, "GoTo Declaration" }
  end
  nmap {
    "gd",
    snacks.lsp_definitions or vim.lsp.buf.definition,
    "GoTo Definitions",
  }

  if client.supports_method "textDocument/implementation" then
    nmap { "gri", snacks.lsp_implementations or vim.lsp.buf.incoming_calls, "incoming-Calls" }
  end

  if client.supports_method "callHierarchy/incomingCalls" then
    nmap { "<leader>li", vim.lsp.buf.incoming_calls, "incoming-Calls" }
  end

  if client.supports_method "textDocument/signatureHelp" then
    ---SignatureHelp
    vim.keymap.set("s", "<C-s>", function()
      vim.lsp.buf.signature_help {
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
    nmap { "<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing-Calls" }
  end
  ---References
  nmap {
    "grr",
    snacks.lsp_references or vim.lsp.buf.references { includeDeclaration = false, loclist = true },
    "GoTo References",
  }

  nmap {
    "<leader>lt",
    snacks.lsp_type_definitions or vim.lsp.buf.type_definition,
    "TypeDef",
  }

  nmap {
    "gO",
    snacks.lsp_symbols or vim.lsp.buf.document_symbol,
    "Workspace Symbols",
  }

  nmap {
    "<leader>lws",
    snacks.lsp_workspace_symbols or vim.lsp.buf.workspace_symbol,
    "Workspace Symbols",
  }
  if client.supports_method "workspace/workspaceFolders" then
    nmap { "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Workspace Add Folder" }
    nmap {
      "<leader>lwr",
      vim.lsp.buf.remove_workspace_folder,
      "Workspace Remove Folder",
    }

    nmap {
      "<leader>lwl",
      function()
        print(table.concat(vim.lsp.buf.list_workspace_folders(), "\n"))
      end,
      "Workspace List Folders",
    }
  end

  nmap { "<leader>la", vim.lsp.buf.code_action, "Code Action" }

  nmap { "<leader>ll", vim.lsp.codelens.run, "CodeLens" }

  -- Enable completion on <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

--- Set buffer capabilities if supported by the passed client and buffer id
--- @param client any client passed to attach config
--- @param bufnr integer buffer id passed to attach config
local function set_buf_funcs_for_capabilities(client, bufnr)
  local usercmd = vim.api.nvim_create_user_command

  -- Completion
  -- NOTE nvim-0.11: still not useful for me, doesn't supports custom snippets
  -- if vim.fn.has "nvim-0.11" == 1 and client.supports_method "textDocument/completion" then
  --   print "Setup completion..."
  --   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  -- end

  -- InlayHints
  if client.supports_method "textDocument/inlayHint" then
    usercmd("ToggleInlayHints", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
    end, { desc = "Toggle Inlay hints" })
  end

  -- lsp-document_highlight
  if client.supports_method "textDocument/documentHighlight" then
    local _lsp_hi_group = vim.api.nvim_create_augroup("_lsp_highlight_group", { clear = true })
    autocmd({ "CursorHold", "CursorHoldI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = function()
        return vim.lsp.buf.document_highlight()
      end,
    })
    autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = _lsp_hi_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
      callback = function()
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = _lsp_hi_group, buffer = bufnr }
      end,
    })
  end

  usercmd("LspCapabilities", function()
    require("lib.lsp").get_current_buf_lsp_capabilities(client, bufnr)
  end, { desc = "List server capabilities" })

  usercmd("ToggleDiagnostics", function()
    require("lib.lsp").toggle_diagnostics(bufnr)
  end, { desc = "List server capabilities" })
end

-- Custom configs to apply when starting lsp
--- @param client table client passed to attach config
local function custom_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
  client.config.flags.debounce_text_changes = 150
end

--- Custom configs to apply when attaching lsp to buffer
--- It setup handlers, keymaps and capabilities
--- @param client table client passed to attach config
--- @param bufnr integer buffer id passed to attach config
local function custom_attach(client, bufnr)
  -- require("plugins.lsp.handlers").setup()

  set_buf_keymaps(client, bufnr)
  set_buf_funcs_for_capabilities(client, bufnr)
end

---Default Lsp Config
lsp.config("*", {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = init_capabilities(),
})

lsp.config("bashls", {
  -- cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  allowList = { "sh", "bash", "zsh" },
  settings = {
    allowList = { "sh", "bash", "zsh" },
    bashIde = {
      shellcheckArguments = {
        "-e",
        "SC2086", -- Double quote to prevent globbing and word splitting
        "-e",
        "SC2155", -- Declare and assign separately to avoid masking return values
      },
    },
  },
})

lsp.config("sqls", {
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
    require("sqls").on_attach(client, bufnr)
  end,
})

lsp.config("jdtls", {
  on_init = function(client)
    custom_init(client)
  end,
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
  end,
})

lsp.config("metals", {
  on_init = function(client)
    custom_init(client)
  end,
  on_attach = function(client, bufnr)
    custom_attach(client, bufnr)
  end,
})

lsp.enable {
  "marksman",
  "gopls",
  "luals",
  "clangd",
  "pyright",
  "bashls",
  "jsonls",
  -- "jdtls",
  "yamlls",
  "sqls",
  "ts_ls",
  "intelephense",
  "texlab",
  "sourcekit",
  "cssls",
  "gradle_ls",
  "lemminx",
  "html",
  "dockerls",
  -- "metals",
}
