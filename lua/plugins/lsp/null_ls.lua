-----------------------------------
--	File: null-ls.lua
--	Description: null-ls plugin config
--	Author: Kevin
--	Last Modified: 31 May 2023, 09:35
-----------------------------------

local M = {
   "jose-elias-alvarez/null-ls.nvim",
   event = "BufReadPre",
   dependencies = {
      "nvim-lua/plenary.nvim",
   },
}

function M.init(opts)
   local null_ls = require "null-ls"

   -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
   local formatting = null_ls.builtins.formatting
   -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
   local diagnostics = null_ls.builtins.diagnostics

   -- https://github.com/prettier-solidity/prettier-plugin-solidity
   -- npm install --save-dev prettier prettier-plugin-solidity
   null_ls.setup {
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
         null_ls.builtins.code_actions.gitsigns.with {
            config = {
               filter_actions = function(title)
                  return title:lower():match "blame" == nil
               end,
            },
         },
         null_ls.builtins.code_actions.gitrebase,
         null_ls.builtins.code_actions.refactoring,
         null_ls.builtins.code_actions.shellcheck,
         -- null_ls.builtins.code_actions.ts_node_action,

         null_ls.builtins.completion.luasnip,
         null_ls.builtins.completion.tags,
         -- nls.builtins.completion.spell,

         null_ls.builtins.diagnostics.standardjs,
         -- null_ls.builtins.diagnostics.markdownlint,
         null_ls.builtins.diagnostics.zsh,

         null_ls.builtins.hover.dictionary,
         null_ls.builtins.hover.printenv,
      },
      on_attach = opts.on_attach,
      root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".git"),
   }

   -- CUSTOM null-ls action
   -- HACK: This is just an example for future use
   -- nls.register {
   --   name = 'my-actions',
   --   method = { require'null-ls'.methods.CODE_ACTION },
   --   filetypes = { '_all' },
   --   generator = {
   --     fn = function()
   --       return {{
   --         title = 'add "hello world"',
   --         action = function()
   --           local current_row = vim.api.nvim_win_get_cursor(0)[1]
   --           vim.api.nvim_buf_set_lines(0, current_row, current_row, true, {'hi mom'})
   --         end
   --       }}
   --     end
   --   }
   -- }
end

return M
