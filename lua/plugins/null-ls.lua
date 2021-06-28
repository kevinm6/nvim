-----------------------------------
--	File: null-ls.lua
--	Description: null-ls plugin config
--	Author: Kevin
--	Last Modified: 06 Jan 2023, 12:35
-----------------------------------

local M = {
  "jose-elias-alvarez/null-ls.nvim",
  event = "BufReadPre",
  dependencies = {
    "nvim-lua/plenary.nvim"
  }
}

function M.init(opts)
  local nls = require "null-ls"

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = nls.builtins.formatting
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = nls.builtins.diagnostics

  -- https://github.com/prettier-solidity/prettier-plugin-solidity
  -- npm install --save-dev prettier prettier-plugin-solidity
  nls.setup {
    debounce = 150,
    save_after_format = false,
    debug = false,
    sources = {
      formatting.prettier.with {
        extra_filetypes = { "toml", "solidity" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      },
      formatting.black.with { extra_args = { "--fast" } },
      formatting.stylua,
      formatting.google_java_format,
      nls.builtins.code_actions.gitsigns,
      -- null_ls.builtins.completion.spell,
      -- null_ls.builtins.completion.luasnip, --using nvim-cmp
    },
    on_attach = opts.on_attach,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git"),
  }
end

return M
