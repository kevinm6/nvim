-------------------------------------
-- File         : lang_specific.lua
-- Description  : language specific plugins
-- Author       : Kevin
-- Last Modified: 06/04/2025 - 18:30
-------------------------------------

vim.pack.add {
  ---Go
  { src = "https://github.com/ray-x/go.nvim", },

  ---Java
  { src = "https://github.com/mfussenegger/nvim-jdtls" },

  ---Scala
  { src = "https://github.com/scalameta/nvim-metals" },

  ---SQL
  { src = "https://github.com/nanotee/sqls.nvim", },

  ---JSON
  { src = "https://github.com/b0o/SchemaStore.nvim" },
}

require("go").setup {
  icons = { breakpoint = "", currentpos = "" },
  diagnostic = {
    signs = { "", "", "", "󱧢" },
  }
}

vim.keymap.set("n", "<leader>df", "<cmd>GoTestFunc<CR>", { desc = "Go Test function" })
vim.keymap.set("n", "<leader>dF", "<cmd>GoTestFile<CR>", { desc = "Go Test File" })
vim.keymap.set("n", "<leader>lh", function()
  local to_search = vim.fn.input "Docs for: "
  if to_search ~= "" then
    vim.cmd.GoDoc(to_search)
  end
end, { desc = "Go Doc" })
