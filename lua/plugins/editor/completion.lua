-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 01 May 2024, 13:25
-------------------------------------

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, o)
      local cmp = require "cmp"
      -- local ls = require "luasnip"
      local icons = require "lib.icons"
      local icons_kind = icons.kind
      local context = require "cmp.config.context"

      o.snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      }

      o.enabled = function()
        return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
      end

      o.mapping = {
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

        -- jump to next porition after modify or complete
        ["<C-l>"] = cmp.mapping(function(fallback)
          if not cmp.visible() then
            fallback()
          elseif not cmp.get_active_entry() then
            return cmp.complete_common_string()
          else
            cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
          end
        end),

        -- next position of snippet $x -> $x+1
        ["<C-i>"] = cmp.mapping(function(fallback)
          if vim.snippet.active { direction = 1 } then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- prev position of snippet $x -> $x-1
        ["<C-S-i>"] = cmp.mapping(function(fallback)
          if vim.snippet.active { direction = -1 } then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- abort completion
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },

        -- confirm completion
        ["<C-y>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Replace },

        -- docs
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
        -- toggle docs on completion
        ["<C-g>"] = function()
          if not cmp.visible_docs() then
            cmp.open_docs()
          else
            cmp.close_docs()
          end
        end,
      }

      o.formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s %s", icons_kind[vim_item.kind], vim_item.kind)

          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            -- luasnip = "[Snip]",
            snippets = "[Snp]",
            buffer = "[Buf]",
            treesitter = "[Trs]",
            otter = "[Ott]",
          })[entry.source.name]

          vim_item.dup = ({
            -- luasnip = 1,
            -- snippets = 1,
            nvim_lsp = 0,
            nvim_lua = 0,
            buffer = 0,
          })[entry.source.name] or 0

          return vim_item
        end,
      }

      o.sources = {
        { name = "nvim_lsp" },
        { name = "otter" },
        {
          name = "buffer",
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },
        {
          name = "snippets",
          filter = function()
            vim.print "Called filter"
            return not context.in_syntax_group "Comment" or not context.in_treesitter_capture "comment"
          end,
        },
        { name = "treesitter" },
        { name = "path", option = { trailing_slash = true } },
        { name = "latex_symbols", keyword_length = 2, priority = 2 },
        { name = "calc", keyword_length = 3 },
      }

      o.confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }

      o.window = {
        completion = cmp.config.window.bordered { scrollbar = false },
        documentation = cmp.config.window.bordered(),
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

      -- per-filetype config
      cmp.setup.filetype("lua", {
        { name = "nvim_lsp" },
        { name = "lazydev", group_index = 0 },
        {
          name = "buffer",
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },
        { name = "snippets" },
        { name = "treesitter" },
        { name = "path", option = { trailing_slash = true } },
        { name = "calc", keyword_length = 3 },
      })

      cmp.setup.filetype({ "markdown", "latex", "text", "quarto" }, {
        sources = {
          { name = "otter" },
          {
            name = "buffer",
            option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
          },
          { name = "treesitter" },
          { name = "snippets" },
          { name = "nvim_lsp" },
          { name = "path", option = { trailing_slash = true } },
          { name = "latex_symbols", keyword_length = 3 },
          { name = "calc", keyword_length = 3 },
        },
      })

      cmp.setup.filetype("help", {
        window = {
          documentation = nil,
        },
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "snippets" },
          { name = "buffer" },
        },
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      cmp.setup.filetype("gitcommit", {
        sources = {
          { name = "gh_issues" },
          { name = "snippets" },
        },
      })

      cmp.setup(o)
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = "nvim-cmp",
    config = function()
      local cmp = require "cmp"

      cmp.setup.cmdline("/", {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        sources = cmp.config.sources {
          { name = "buffer", length = 2 },
          { name = "treesitter", length = 3 },
        },
      })

      cmp.setup.cmdline(":", {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path", option = { trailing_slash = true }, length = 2 },
        }, {
          { name = "cmdline", length = 3 },
        }),
      })
    end,
  },
  { "hrsh7th/cmp-buffer", event = "BufRead" },
  { "hrsh7th/cmp-path", event = "BufRead" },
  { "hrsh7th/cmp-calc", event = "BufRead" },
  {
    "kdheepak/cmp-latex-symbols",
    ft = "markdown",
  },
  {
    "rcarriga/cmp-dap",
    ft = { "dap-repl", "dapui_watches", "dapui_hover" },
  },
  {
    "garymjr/nvim-snippets",
    event = "InsertEnter",
    dependencies = { "kevinm6/snippets", dev = true },
    opts = function(_, o)
      o.extended_filetypes = {
        typescript = { "javascript", "tsdoc" },
        javascript = { "jsdoc" },
        html = { "css", "javascript" },
        lua = { "luadoc", "nvim_lua" },
        python = { "python-docstring" },
        java = { "javadoc", "java-testing" },
        sh = { "shelldoc" },
        php = { "phpdoc" },
        ruby = { "rdoc" },
        quarto = { "markdown" },
        rmarkdown = { "markdown" },
      }
      o.search_paths = { vim.env.HOME .. "/dev/snippets" }
    end,
  },
}
