-------------------------------------
-- File         : ts_highlight_current_scope.lua
-- Description  : utils function for treesitter (revamp of `nvim-treesitter-refactor`)
-- Author       : Kevin
-- Last Modified: 28/05/2025, 08:46
-------------------------------------

local M = {}

---Go to usage of variable under cursor
---@param direction string<"prev","next">
local function goto_variable_usage(direction)
  local ts = vim.treesitter

  local node = ts.get_node({ ignore_injections = true })

  if not node then
    vim.notify("No Tree-sitter node found under cursor", vim.log.levels.WARN)
    return
  end

  -- Climb to the identifier if needed
  while node and node:type() ~= "identifier" do
    node = node:parent()
  end

  if not node or node:type() ~= "identifier" then
    vim.notify("Not on an identifier", vim.log.levels.WARN)
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
    vim.notify("No " .. direction .. " usage found", vim.log.levels.INFO)
  end
end

---GoTo Definition
local function goto_definition()
  local ts_utils = vim.treesitter
  local node = ts_utils.get_node({ ignore_injections = true })

  if not node then
    vim.notify("No Tree-sitter node found", vim.log.levels.WARN)
    return
  end

  -- Climb to `identifier` node
  while node and node:type() ~= "identifier" do
    node = node:parent()
  end

  if not node then
    vim.notify("Not on an identifier", vim.log.levels.WARN)
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
    vim.notify("Definition not found (Tree-sitter or LSP)", vim.log.levels.INFO)
  end
end

function M.attach(bufnr)
  vim.keymap.set("n", "<C-j>", function()
    goto_variable_usage("next")
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_next_usage" })
  vim.keymap.set("n", "<C-k>", function()
    goto_variable_usage("prev")
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_previous_usage" })
  vim.keymap.set("n", "gd", function()
    goto_definition()
  end, { buffer = bufnr, silent = true, noremap = true, desc = "goto_definition" })
end

function M.detach(bufnr)
  local api = vim.api

  api.nvim_buf_del_keymap(bufnr, "n", "<C-j>")
  api.nvim_buf_del_keymap(bufnr, "n", "<C-k>")
  api.nvim_buf_del_keymap(bufnr, "n", "gd")
  api.nvim_buf_del_keymap(bufnr, "n", "gD")
  api.nvim_buf_del_keymap(bufnr, "n", "gO")
end

return M