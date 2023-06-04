-----------------------------------
--	File: null-ls.lua
--	Description: null-ls plugin config
--	Author: Kevin
--	Last Modified: 10 Jun 2023, 09:00
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
   -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
   local code_actions = null_ls.builtins.code_actions

   -- https://github.com/prettier-solidity/prettier-plugin-solidity
   -- npm install --save-dev prettier prettier-plugin-solidity
   null_ls.setup {
      debounce = 150,
      save_after_format = false,
      debug = false,
      sources = {
         formatting.prettier.with {
            extra_filetypes = { "toml", "solidity" },
            extra_args = function(params)
               return params.options
                  and {
                     "--no-semi",
                     "--single-quote",
                     "--jsx-single-quote",
                  }
                  and params.options.tabSize
                  and { "--tab-width", params.options.tabSize }
            end,
         },
         formatting.black.with {
            extra_args = function(params)
               return params.options
                  and { "--fast" }
                  and params.options.tabSize
                  and { "--tab-width", params.options.tabSize }
            end,
         },
         formatting.stylua.with {
            extra_args = function(params)
               return params.options
                  and params.options.tabSize
                  and { "--indent-width", params.options.tabSize }
            end,
         },
         formatting.google_java_format.with {
            extra_args = function(params)
               return params.options
                  and params.options.tabSize
                  and { "--tab-width", params.options.tabSize }
            end,
         },

         formatting.yamlfmt.with {
            extra_args = function(params)
               return params.options
                  and params.options.tabSize
                  and { "--tab-width", params.options.tabSize }
            end,
         },

         code_actions.gitsigns.with {
            config = {
               filter_actions = function(title)
                  return title:lower():match "blame" == nil
               end,
            },
         },
         code_actions.gitrebase,
         code_actions.refactoring,
         -- code_actions.shellcheck,
         -- null_ls.builtins.code_actions.ts_node_action,

         null_ls.builtins.completion.luasnip,
         null_ls.builtins.completion.tags,
         -- nls.builtins.completion.spell,

         -- diagnostics.standardjs,
         -- null_ls.builtins.diagnostics.markdownlint,
         diagnostics.zsh,

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
