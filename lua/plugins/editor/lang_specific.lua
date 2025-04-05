-------------------------------------
-- File         : lang_specific.lua
-- Description  : language specific plugins
-- Author       : Kevin
-- Last Modified: 06/04/2025 - 18:30
-------------------------------------

return {
  ---Go
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    opts = function(_, o)
      o.icons = { breakpoint = "", currentpos = "" }
      o.diagnostic = {
        signs = { "", "", "", "󱧢" },
      }
      require("go").setup(o)

      vim.keymap.set("n", "<leader>df", "<cmd>GoTestFunc<CR>", { desc = "Go Test function" })
      vim.keymap.set("n", "<leader>dF", "<cmd>GoTestFile<CR>", { desc = "Go Test File" })
      vim.keymap.set("n", "<leader>lh", function()
        local to_search = vim.fn.input "Docs for: "
        if to_search ~= "" then
          vim.cmd.GoDoc(to_search)
        end
      end, { desc = "Go Doc" })
    end,
  },

  ---Java
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  ---Scala
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
  },

  ---SQL
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
  },

  ---JSON
  {
    "b0o/SchemaStore.nvim",
    ft = { "json", "yaml" },
  },
}
