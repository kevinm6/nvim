-------------------------------------
-- title: ts_highlight_current_scope.lua
-- abstract: utils function for treesitter (revamp of `nvim-treesitter-refactor`)
-- author: Kevin
-- date: 28 Mar 2026, 19:36
-------------------------------------

local M = {}

---Get treesitter parsers to be installed
---@return table list of parsers
function M.parsers_to_be_installed()
  return {
    "bash",
    "comment",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "dtd",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "gowork",
    "groovy",
    "html",
    "http",
    "ini",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "latex",
    "lua",
    "markdown_inline",
    "markdown",
    "matlab",
    "php_only",
    "php",
    "phpdoc",
    "python",
    "regex",
    "ruby",
    "scheme",
    "scss",
    "sql",
    "svelte",
    "swift",
    "todotxt",
    "tsx",
    "typescript",
    "typst",
    "vim",
    "vimdoc",
    "vue",
    "xml",
    "yaml",
    "ini",
    -- "neverlang"
  }
end

---Remove installed treesitter parsers
function M.uninstall_parsers()
  local parsers = vim.fn.glob(vim.fn.stdpath "data" .. "/site/parser/*.*", true, true)
  local numParsers = #parsers
  if numParsers < 1 then
    vim.notify("TS Utils - no parser installed", vim.log.levels.INFO, { title = "TS Utils" })
    return
  end
  vim.fn.confirm("Are you sure to uninstall all treesitter parsers?", "&Yes\n&No", 2, "WARN")

  for _, parser in pairs(parsers) do
    vim.fn.delete(parser)
  end
  vim.notify(("TS utils - %d parsers deleted"):format(#numParsers), vim.log.levels.WARN, { title = "TS Utils" })
end

---Go to usage of variable under cursor
---@param direction string<"prev","next">
local function goto_variable_usage(direction)
  local ts = vim.treesitter

  local node = ts.get_node({ ignore_injections = true })

  if not node then
    vim.notify("Treesitter - no ts_node found under cursor", vim.log.levels.WARN)
    return
  end

  -- Climb to the identifier if needed
  while node and node:type() ~= "identifier" do
    node = node:parent()
  end

  if not node or node:type() ~= "identifier" then
    vim.notify("Treesitter - not on an identifier", vim.log.levels.WARN)
    return
  end

  local name = ts.get_node_text(node, 0)
  local root = ts.get_parser(0):parse()[1]:root()
  local results = {}

  local function find_identifiers(n)
    if n:type() == "identifier" and ts.get_node_text(n, 0) == name then
      table.insert(results, n)
    end
    for child in n:iter_children() do
      find_identifiers(child)
    end
  end

  find_identifiers(root)

  -- Sort them by buffer position
  table.sort(results, function(a, b)
    local ar, ac = a:range()
    local br, bc = b:range()
    if ar == br then
      return ac < bc
    else
      return ar < br
    end
  end)

  -- Get current cursor position
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  cursor_row = cursor_row - 1 -- converted to 0-based
  local target = nil

  if direction == "next" then
    for _, n in ipairs(results) do
      local row, col = n:range()
      if row > cursor_row or (row == cursor_row and col > cursor_col) then
        target = n
        break
      end
    end
  elseif direction == "prev" then
    for i = #results, 1, -1 do
      local n = results[i]
      local row, col = n:range()
      if row < cursor_row or (row == cursor_row and col < cursor_col) then
        target = n
        break
      end
    end
  end

  if target then
    local row, col = target:range()
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  else
    vim.notify("Treesitter -  no " .. direction .. " usage found", vim.log.levels.INFO)
  end
end

---GoTo Definition
local function goto_definition()
  local ts_utils = vim.treesitter
  local node = ts_utils.get_node({ ignore_injections = true })

  if not node then
    vim.notify("Treesitter - no ts_node found", vim.log.levels.WARN)
    return
  end

  -- Climb to `identifier` node
  while node and node:type() ~= "identifier" do
    node = node:parent()
  end

  if not node then
    vim.notify("Treesitter - not on an identifier", vim.log.levels.WARN)
    return
  end

  local name = vim.treesitter.get_node_text(node, 0)
  local root = ts_utils.get_parser(0):parse()[1]:root()

  local definition_node = nil

  local function find_definition(n)
    if n:type() == "function_declaration" or n:type() == "lexical_declaration" or n:type():find("assignment") then
      for child in n:iter_children() do
        if vim.treesitter.get_node_text(child, 0) == name then
          definition_node = n
          return true
        end
      end
    end
    for child in n:iter_children() do
      if find_definition(child) then
        return true
      end
    end
    return false
  end

  find_definition(root)

  if definition_node then
    local row, col = definition_node:range()
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
  else
    -- Fallback to LSP
    local params = vim.lsp.util.make_position_params(0, vim.bo.fileencoding)
    local result = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 500)

    for _, res in pairs(result or {}) do
      if res.result and res.result[1] then
        local loc = res.result[1]
        -- vim.lsp.util.jump_to_location(loc, vim.bo.fileencoding)
        vim.lsp.util.show_document(loc, vim.bo.fileencoding, { focus = true })
        return
      end
    end
    vim.notify("Treesitter - definition not found (Treesitter or LSP)", vim.log.levels.INFO)
  end
end


local function detach(bufnr)
  local del_keymap = vim.api.nvim_buf_del_keymap
  del_keymap(bufnr, "n", "<C-j>")
  del_keymap(bufnr, "n", "<C-k>")
  del_keymap(bufnr, "n", "gd")
  del_keymap(bufnr, "n", "gD")
  del_keymap(bufnr, "n", "gO")
end

function M.attach(bufnr)
  local set_keymap = vim.keymap.set
  set_keymap("n", "<C-j>", function()
    goto_variable_usage("next")
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_next_usage" })
  set_keymap("n", "<C-k>", function()
    goto_variable_usage("prev")
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_previous_usage" })
  set_keymap("n", "gd", function()
    goto_definition()
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_definition" })

  vim.api.nvim_create_autocmd("BufDelete", {
    pattern = M.parsers_to_be_installed(),
    callback = function()
      detach(bufnr)
    end
  })
end

return M