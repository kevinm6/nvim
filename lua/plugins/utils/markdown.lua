-------------------------------------
--  File         : markdown.lua
--  Description  : markdown specific plugin configs
--  Author       : Kevin
--  Last Modified: 24 Jul 2024, 08:51
-------------------------------------

-- Parse query outside of the function to avoid doing it for each call
-- local query = vim.treesitter.query.parse("markdown_inline", "(inline (html_tag) @capture)")
-- local function parse_html_md(root, buf)
--   local marks = {}
--   for id, node in query:iter_captures(root, buf) do
--     local capture = query.captures[id]
--     local start_row, _, _, _ = node:range()
--     if capture == "capture" then
--       table.insert(marks, {
--         conceal = true,
--         start_row = start_row,
--         start_col = 0,
--         opts = {
--           end_row = start_row + 1,
--           end_col = 0,
--           hl_group = "DiffDelete",
--           hl_eol = true,
--         },
--       })
--     end
--   end
--   return marks
-- end
-- o.custom_handlers = {
--   file_types = { "markdown_inline", "markdown" },
--   markdown = { parse = parse_html_md },
-- }

return {
  "MeanderingProgrammer/markdown.nvim",
  main = "render-markdown",
  ft = { "markdown", "quarto" },
  -- keys = {
  --   {
  --     "<localleader>r",
  --     { "markdown", "quarto" },
  --     desc = "Render Markdown",
  --   },
  -- },
  opts = function(_, o)
    o.enabled = false -- not rendering on enter md files
    o.file_types = { "markdown", "quarto", "markdown.mdx" } -- TODO to test
    o.anti_conceal = { enabled = false }
    o.latex = {
      enabled = false,
      converter = "utftex",
    }
    o.acknowledge_conflicts = true
    o.heading = {
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
    }
    o.checkbox = {
      unchecked = { -- Replaces '[ ]' of 'task_list_marker_unchecked'
        icon = "󰄱 ",
      },
      checked = { -- Replaces '[x]' of 'task_list_marker_checked'
        icon = "󰄵 ",
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
      },
    }

    vim.keymap.set("n", "<localleader>r", function()
      require("render-markdown").toggle()
    end, { buffer = true, desc = "Render Markdown" })

    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "TabLine" })
  end,
}