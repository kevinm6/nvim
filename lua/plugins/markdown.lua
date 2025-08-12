-------------------------------------
--  File         : markdown.lua
--  Description  : markdown specific plugin configs
--  Author       : Kevin
--  Last Modified: 12/08/2025, 09:34
-------------------------------------

vim.pack.add { "https://github.com/MeanderingProgrammer/markdown.nvim" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto" },
  callback = function()
    require("render-markdown").setup {
      -- keys = {
      --   {
      --     "<localleader>r",
      --     { "markdown", "quarto" },
      --     desc = "Render Markdown",
      --   },
      -- },
      enabled = false, -- not rendering on enter md files
      file_types = { "markdown", "quarto", "markdown.mdx" },
      anti_conceal = { enabled = false },
      latex = {
        enabled = false,
        converter = "utftex",
      },
      acknowledge_conflicts = true,
      heading = {
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      checkbox = {
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
    }

    vim.api.nvim_set_hl(0, "RenderMarkdownCode", { link = "TabLine" })
  end
})