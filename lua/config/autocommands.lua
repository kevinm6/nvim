-------------------------------------
-- File         : autocommands.lua
-- Description  : Autocommands config
-- Author       : Kevin
-- Last Modified: 06 Apr 2023, 17:23
-------------------------------------

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

-- General
local _general_settings = augroup("_general_settings", {
  clear = true,
})

autocmd({ "FileType" }, {
  group = _general_settings,
  pattern = {
    "qf", "help", "git*", "lspinfo", "tsplayground", "crunner",
    "Scratch", "checkhealth", "sqls_output", "DressingSelect", "Jaq", "noice.log"
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { buffer = true, silent = true })
  end
})

autocmd({ "BufReadPre" }, {
  group = _general_settings,
  pattern = { "*.png", "*.jpg", "*.jpeg" },
  callback = function(data)
    local buf = vim.api.nvim_get_current_buf()
    local match = data.match
    -- vim.pretty_print(match)
    local startline = -2
    local endline = -1

    if vim.endswith(match, "png") then
      vim.api.nvim_buf_set_option(buf, "filetype", "png")
    elseif vim.endswith(match, "jpeg") or vim.endswith(match, "jpg") then
      vim.api.nvim_buf_set_option(buf, "filetype", "jpg")
    end
    vim.api.nvim_buf_set_lines(buf, startline, endline, false, "")
  end
})

autocmd({ "FileType" }, {
  group = _general_settings,
  pattern = { "man", "diff" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>quit<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "<esc>", "<cmd>quit<CR>", { buffer = true, silent = true })
  end
})

autocmd({ "TextYankPost" }, {
  group = _general_settings,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "TextYankPost", timeout = 80, on_macro = true })
  end
})



-- Statusline
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  group = vim.api.nvim_create_augroup("_statusline", { clear = true, }),
  pattern = "*",
  callback = function()
    vim.wo.statusline = "%!v:lua.require'core.statusline'.get_statusline()"
  end,
})

-- WinBar
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  group = vim.api.nvim_create_augroup("_winbar", { clear = true }),
  callback = function()
    local has_float_win, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
    if not has_float_win then
      vim.wo.winbar = require "core.winbar".get_winbar()
    end
  end,
})


autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.name == "jdtls" then return end
    -- local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, { buffer = args.buf, desc = "Open float" })
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = args.buf })

    if client.server_capabilities.declarationProvider then
      vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { buffer = args.buf, desc = "GoTo declaration" })
    end
    if client.server_capabilities.definitionProvider then
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { buffer = args.buf, desc = "GoTo definition" })
    end
    if client.server_capabilities.implementationProvider then
      vim.keymap.set("n", "gI", function() vim.lsp.buf.implementation() end, { buffer = args.buf, desc = "GoTo implementation" })
    end
    if client.server_capabilities.referencesProvider then
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { buffer = args.buf, desc = "GoTo references" })
    end
    -- if client.server_capabilities.referencesProvider then
    vim.keymap.set("n", "<leader>ll", function() vim.lsp.codelens.run() end, { buffer = args.buf, desc = "CodeLens Action" })
    -- end

    -- Formatting
    -- if client.server_capabilities.documentFormattingProvider then
    if  client.supports_method("textDocument/formatting") then
      local lsp_formatting = function(bufnr)
          vim.lsp.buf.format({
              filter = function()
                  -- apply whatever logic you want (in this example, we'll only use null-ls)
                  return client.name == "null-ls"
              end,
              bufnr = bufnr,
          })
      end

      -- Format on save
      local function format_on_save(enable)
        local action = function() return enable and "Enabled" or "Disabled" end

        if enable then
          vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = vim.api.nvim_create_augroup("_format_on_save", { clear = true }),
            pattern = "*",
            callback = function()
              lsp_formatting(args.buf)
            end,
          })
        else
          vim.api.nvim_clear_autocmds { group = "format_on_save" }
        end

        vim.notify(action().. " format on save", "Info", { title = "LSP" })
      end

      vim.api.nvim_create_user_command("LspToggleAutoFormat", function()
        if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
          format_on_save(true)
        else
          format_on_save()
        end
      end, {})

      vim.api.nvim_buf_create_user_command(0, "Format", function()
        vim.lsp.buf.format()
      end, { force = true })

      vim.keymap.set("n", "<leader>lf", function()
        lsp_formatting(args.buf)
      end, { desc = "Format" })
      vim.keymap.set("n", "<leader>lF", function()
        vim.cmd.LspToggleAutoFormat()
      end, { desc = "Toggle AutoFormat" })
    end

    -- lsp-document_highlight
    if client.server_capabilities.documentHighlightProvider then
      local lsp_hi_doc_group = vim.api.nvim_create_augroup("_lsp_document_highlight", { clear = true })
      autocmd({ "BufEnter", "CursorHold", "CursorHoldI" }, {
        group = lsp_hi_doc_group,
        buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
        callback = function () vim.lsp.buf.document_highlight() end
      })
      autocmd({ "BufEnter", "CursorMoved" }, {
        group = lsp_hi_doc_group,
        buffer = args.buf, -- passing buffer instead of pattern to prevent errors on switching bufs
        callback = function() vim.lsp.buf.clear_references() end
      })
    end

    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { buffer = args.buf, desc = "Code Action" })
    vim.keymap.set("n", "<leader>lI", function() vim.cmd.LspInfo {} end, { buffer = args.buf, desc = "Lsp Info" })
    vim.keymap.set("n", "<leader>lL", function() vim.cmd.LspLog {} end, { buffer = args.buf, desc = "Lsp Log" })
    vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, { buffer = args.buf, desc = "Rename" })
    vim.keymap.set("n", "<leader>lq", function() vim.diagnostic.setloclist() end, { buffer = args.buf, desc = "Lsp Diagnostics" })
    -- Diagnostics
    vim.keymap.set("n", "<leader>dj", function() vim.diagnostic.goto_next { buffer = args.buf } end, { desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>dk", function() vim.diagnostic.goto_prev { buffer = args.buf } end, { desc = "Prev Diagnostic" })
  end
})


-- If buffer modified, update any 'Last modified: ' in the first 10 lines.
-- Restores cursor and window position using save_cursor variable.
local updateTimeStamp = autocmd({ "BufWritePre" }, {
  group = _general_settings,
  pattern = "*",
  callback = function()
    if vim.opt_local.modified._value == true then
      local cursor_pos = vim.api.nvim_win_get_cursor(0)

      vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
      vim.fn.histdel('search', -1)
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end
})

local autoTimeStampID = updateTimeStamp


command("ToggleTimeStamp",
  function()
    local au = vim.api.nvim_get_autocmds({ group = _general_settings, event = "BufWritePre", pattern = "*" })
    if (autoTimeStampID ~= nil and au[1] ~= nil) then
      -- remove autocmd if exists and match w/ the one created
      --[[ print(au[1].id == toggleUpdateTimeStamp) ]]
      if au[1].id == autoTimeStampID then
        vim.api.nvim_del_autocmd(autoTimeStampID)
        autoTimeStampID = nil
        vim.notify("❌ TimeStamp update on save disabled.", "Info", { title = "Update file INFO" })
      end
    else
      autoTimeStampID = autocmd({ "BufWritePre" }, {
        group = _general_settings,
        pattern = "*",
        callback = function()
          if vim.opt_local.modified._value == true then
            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            vim.api.nvim_command [[silent! 0,10s/Last Modified:.\(.\+\)/\=strftime('Last Modified: %d %h %Y, %H:%M')/g ]]
            vim.fn.histdel('search', -1)
            vim.api.nvim_win_set_cursor(0, cursor_pos)
          end
        end
      })

      vim.notify("✅ TimeStamp update on save enabled.", "Info", { title = "Update file INFO" })
    end
  end,
  { desc = "Update TimeStamp on save" }
)

-- Jump to last < cursor-pos > in file
autocmd({ "BufRead" }, {
  group = _general_settings,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end
})


-- Git
autocmd({ "FileType", "BufNewFile" }, {
  group = _general_settings,
  pattern = { "gitcommit", "gitrebase" },
  callback = function() vim.cmd.startinsert() end
})


-- Markdown
autocmd({ "BufNewFile", "BufRead" }, {
  group = augroup("_markdown", { clear = true }),
  pattern = { "*.markdown", "*.mdown", "*.mkd", "*.mkdn", "*.md" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "filetype", "markdown")
  end
})

-- Java
autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end
})

-- SQL
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("_sql", { clear = true }),
  pattern = "*.psql*",
  callback = function()
    vim.api.nvim_buf_set_option(0, "filetype", "sql")
  end
})

-- Kitty conf files
autocmd({ "BufRead" }, {
  group = augroup("_kitty", { clear = true }),
  pattern = { "kitty.conf", "*/kitty/*.conf", "*/kitty/*.session" },
  callback = function()
    vim.api.nvim_buf_set_option(0, "filetype", "kitty")
    vim.api.nvim_buf_set_option(0, "comments", ":#,:#\\:")
    vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
  end
})


-- Scratch
local Scratch = function()
  vim.cmd.new ""
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Scratch"
end

command("Scratch", Scratch, { desc = "Create a Scratch buffer" })

-- Note
local Note = function()
  vim.cmd.new ""
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "hide"
  vim.opt_local.buflisted = false
  vim.opt_local.swapfile = false
  vim.opt_local.filetype = "Note"
end

command("Note", Note, { desc = "Create a Note buffer" })

-- Remove trailing spaces
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if not vim.bo.filetype == "markdown" then return end
    vim.cmd [[%s/\s\+$//e]]
  end
})
command("RemoveTrailingSpaces", [[%s/\s\+$//e]], { desc = "Remove extra trailing white spaces" })

local DeleteCurrentBuffer = function()
  local cBuf = vim.api.nvim_get_current_buf()
  local bufs = vim.fn.getbufinfo({ buflisted = true })
  if #bufs == 0 then return end

  for idx, b in ipairs(bufs) do
    if b.bufnr == cBuf then
      if idx == #bufs then
        vim.cmd.bprevious {}
      else
        vim.cmd.bnext {}
      end
      break
    end
  end
  vim.cmd.bdelete(cBuf)
end

command("DeleteCurrentBuffer", DeleteCurrentBuffer, { desc = "Close current buffer and go to next" })

command("CheatSH", function(args)
  require "util.cheatSH.cheat_sheet".run(args)
end, {
    nargs = "?",
    desc = "Cheat-Sheet",
    complete = "filetype"
  })

-- compare changes in the current buffer with a related file on your disk,
-- before it will be saved, if Git does not track this file yet
-- @help :h usr_05.txt
command("DiffOrig", function()
  -- Get start buffer
  local start = vim.api.nvim_get_current_buf()

  -- `vnew` - Create empty vertical split window
  -- `set buftype=nofile` - Buffer is not related to a file, will not be written
  -- `0d_` - Remove an extra empty start row
  -- `diffthis` - Set diff mode to a new vertical split
  vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')

  -- Get scratch buffer
  local scratch = vim.api.nvim_get_current_buf()

  -- `wincmd p` - Go to the start window
  -- `diffthis` - Set diff mode to a start window
  vim.cmd('wincmd p | diffthis')

  -- Map `q` for both buffers to exit diff view and delete scratch buffer
  for _, buf in ipairs({ scratch, start }) do
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', 'q', { buffer = start })
    end, { buffer = buf })
  end
end, {})


require "util.hex.hex".setup {}
