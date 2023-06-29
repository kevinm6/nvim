-------------------------------------
-- File         : cmp.lua
-- Description  : Lua K NeoVim & VimR cmp config
-- Author       : Kevin
-- Last Modified: 11 Jul 2023, 17:54
-------------------------------------

local M = {
   "hrsh7th/nvim-cmp",
   event = "InsertEnter",
   dependencies = {
      { "kevinm6/the-snippets", dev = true },
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      { "ray-x/cmp-treesitter", dependencies = { "nvim-treesitter/nvim-treesitter" } },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },
      "hrsh7th/cmp-path",
      { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
      "hrsh7th/cmp-calc",
      { "kdheepak/cmp-latex-symbols", ft = "markdown" },
   },
   opts = function(_, o)
      local cmp = require "cmp"
      local cmp_dap = require "cmp_dap"
      local ls = require "luasnip"
      local icons = require "user_lib.icons"
      local icons_kind = icons.kind
      local context = require "cmp.config.context"

      o.snippet = {
         expand = function(args)
            ls.lsp_expand(args.body)
         end,
      }

      o.enabled = function()
         return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or cmp_dap.is_dap_buffer()
      end

      o.mapping = cmp.mapping.preset.insert {
         ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

         ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

         ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
         ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
         ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

         ["<C-l>"] = cmp.mapping(function()
            if cmp.visible() then
               cmp.abort()
            end
         end, { "i", "c" }),

         ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
         },

         ["<C-o>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
         },

         ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
         },
         ["<C-i>"] = cmp.mapping(function(fallback)
            if ls.expand_or_jumpable() then
               ls.expand_or_jump()
            else
               fallback()
            end
         end, { "i", "s" }),
         ["<Right>"] = cmp.mapping.confirm { select = true },

         ["<M-CR>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),

         ["<Tab>"] = cmp.mapping(function(fallback)
            if ls.expand_or_jumpable() then
               ls.expand_or_jump()
            else
               fallback()
            end
         end, { "i", "s" }),
         ["<S-Tab>"] = cmp.mapping(function(fallback)
            if ls.expand_or_jumpable() then
               ls.expand_or_jump()
            else
               fallback()
            end
         end, { "i", "s" }),

         ["<Up>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            else
               fallback()
            end
         end, { "i" }),

         ["<Down>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            else
               fallback()
            end
         end, { "i" }),
      }

      o.formatting = {
         fields = { "abbr", "kind", "menu" },
         format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", icons_kind[vim_item.kind], vim_item.kind)
            vim_item.dup = ({
              luasnip = 0,
              nvim_lsp = 0,
              nvim_lua = 0,
              buffer = 0,
            })[entry.source.name] or 0

            return vim_item
         end,
      }

      o.sources = {
         {
            name = "nvim_lsp",
            priority = 9,
            filter = function(_, _)
               return not context.in_syntax_group "Comment"
                  or not context.in_treesitter_capture "comment"
            end,
         },
         {
            name = "luasnip",
            priority = 9,
            filter = function(_, _)
               return not context.in_syntax_group "Comment"
                  or not context.in_treesitter_capture "comment"
            end,
         },
         {
            name = "dap",
            priority = 6,
            filter = function(_, _)
               return not context.in_syntax_group "Comment"
                  or not context.in_treesitter_capture "comment"
            end,
         },
         {
            name = "nvim_lsp_signature_help",
            filter = function(_, _)
               return not context.in_syntax_group "Comment"
                  or not context.in_treesitter_capture "comment"
            end,
         },
         { name = "treesitter", priority = 6 },
         {
            name = "buffer",
            option = { keyword_length = 3, keyword_pattern = [[\k\+]] },
            priority = 8,
         },
         { name = "path", option = { trailing_slash = true } },
         { name = "latex_symbols", keyword_length = 2, priority = 2 },
         { name = "calc" },
      }

      o.confirm_opts = {
         behavior = cmp.ConfirmBehavior.Replace,
         select = false,
      }

      o.window = {
         documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "NormalFloat:Pmenu,NormalFloat:Pmenu,CursorLine:PmenuSel,Search:None",
         },
      }

      o.experimental = {
         ghost_text = {
            enable = true,
            hl_group = "Comment",
         },
      }

   end,
   config = function(_, o)
      -- Cmp Configuration
      local cmp = require "cmp"
      cmp.setup(o)

      -- per-filetype config
      -- cmp.setup.filetype("markdown", {
      --    sources = cmp.config.sources {
      --       { name = "nvim_lsp", priority = 7, dup = 0 },
      --       { name = "luasnip", priority = 8, dup = 0 },
      --       {
      --          name = "buffer",
      --          option = { keyword_length = 3, keyword_pattern = [[\k\+]] },
      --          priority = 8,
      --          dup = 0,
      --       },
      --       { name = "treesitter", priority = 6 },
      --       { name = "path", option = { trailing_slash = true } },
      --       { name = "latex_symbols", keyword_length = 2, priority = 4 },
      --       { name = "calc" },
      --    },
      -- })

      cmp.setup.filetype("help", {
         window = {
            documentation = cmp.config.disable,
         },
      })

      cmp.setup.cmdline("/", {
         sources = cmp.config.sources({
            { name = "nvim_lsp_document_symbol" },
         }, {
            { name = "buffer" },
         }),
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
         sources = {
            { name = "dap" },
         },
      })
   end
}

return M
