-------------------------------------
-- File         : completion.lua
-- Description  : completion config
-- Author       : Kevin
-- Last Modified: 10 Jul 2024, 09:12
-------------------------------------

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function(_, o)
      local cmp = require "cmp"
      local icons = require "mini.icons"
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
        ["<C-l>"] = cmp.mapping(function()
          if not cmp.visible() then
            return
          else
            return not cmp.get_active_entry() and cmp.complete_common_string()
              or cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
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
          vim_item.kind = string.format("%s %s", icons.get("lsp", vim_item.kind), vim_item.kind)

          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            snippets = "[Snip]",
            buffer = "[Buf]",
            latex_symbols = "[LaTeX]",
            path = "[Path]",
            calc = "[Calc]",
          })[entry.source.name]

          -- vim_item.dup = ({
          --   -- luasnip = 1,
          --   -- snippets = 1,
          --   nvim_lsp = 0,
          --   nvim_lua = 0,
          --   buffer = 0,
          -- })[entry.source.name] or 0
          return vim_item
        end,
      }

      o.sources = {
        { name = "nvim_lsp" },
        {
          name = "buffer",
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },
        {
          name = "snippets",
          filter = function()
            return not context.in_syntax_group "Comment" or not context.in_treesitter_capture "comment"
          end,
        },
        -- { name = "treesitter" },
        { name = "path", option = { trailing_slash = true } },
        { name = "calc", option = { keyword_length = 3 } },
      }

      o.confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }

      -- o.window = {
      --   completion = cmp.config.window.bordered { scrollbar = false },
      --   documentation = cmp.config.window.bordered {
      --     border = "single",
      --     scrollbar = false,
      --     max_width = math.floor(vim.o.columns * 0.6),
      --     max_height = math.floor(vim.o.lines * 0.4),
      --   },
      -- }
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
      local context = require "cmp.config.context"

      -- per-filetype config
      cmp.setup.filetype("lua", {
        { name = "nvim_lsp" },
        { name = "lazydev", group_index = 0 },
        {
          name = "buffer",
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },
        {
          name = "snippets",
          filter = function()
            return not context.in_syntax_group "Comment" or not context.in_treesitter_capture "comment"
          end,
        },
        -- { name = "treesitter" },
        { name = "path", option = { trailing_slash = true } },
        { name = "calc", keyword_length = 3 },
      })

      cmp.setup.filetype({ "markdown", "text", "quarto", "qmd" }, {
        sources = {
          {
            name = "buffer",
            option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
          },
          { name = "nvim_lsp" },
          { name = "snippets" },
          { name = "path", option = { trailing_slash = true } },
          { name = "obsidian" },
          { name = "obsidian_new" },
          { name = "obsidian_tags" },
          { name = "latex_symbols", option = { keyword_length = 2, priority = 2 } },
          { name = "calc", keyword_length = 3 },
        },
      })

      cmp.setup.filetype({ "tex" }, {
        sources = {
          { name = "vimtex" }, -- trigger_characters = { "{", "\\" } },
          { name = "snippets", keyword_length = 2 },
          { name = "nvim_lsp" },
          { name = "buffer", option = { keyword_length = 4, keyword_pattern = [[\k\+]] } },
          { name = "path", option = { trailing_slash = true } },
          { name = "calc", keyword_length = 3 },
        },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s %s", require("mini.icons").get("lsp", vim_item.kind), vim_item.kind)

          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            snippets = "[Snip]",
            buffer = "[Buf]",
            vimtex = "[TeX]",
            latex_symbols = "[LaTeX]",
            path = "[Path]",
            calc = "[Calc]",
          })[entry.source.name]
          return vim_item
        end,
      })

      cmp.setup.filetype("help", {
        window = {
          documentation = nil,
        },
      })

      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "nvim_lsp" },
          -- { name = "treesitter" },
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
  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    config = function()
      local cmp = require "cmp"

      cmp.setup.cmdline("/", {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        sources = cmp.config.sources {
          { name = "buffer", length = 2 },
          -- { name = "treesitter", length = 3 },
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
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
  { "hrsh7th/cmp-buffer", event = "BufRead" },
  { "hrsh7th/cmp-path", event = "BufRead" },
  { "hrsh7th/cmp-calc", event = "BufRead" },
  {
    "kdheepak/cmp-latex-symbols",
    ft = { "markdown" },
    -- event = { "BufRead", "InsertEnter" }
  },
  { "micangl/cmp-vimtex", ft = { "tex" } },
  { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },

  { "kevinm6/snippets", dev = true },
  {
    "garymjr/nvim-snippets",
    event = "InsertEnter",
    opts = {
      -- TODO on nvim-0.11 => set when activating built-in completion (w/o nvim-cmp)
      -- o.create_cmp_source = false
      extended_filetypes = {
        typescript = { "javascript", "tsdoc" },
        javascript = { "jsdoc" },
        html = { "css", "javascript" },
        lua = { "luadoc", "nvim_lua" },
        python = { "python-docstring" },
        java = { "javadoc", "java-testing" },
        sh = { "shelldoc" },
        php = { "phpdoc" },
        ruby = { "rdoc" },
        quarto = { "quarto", "markdown", "md" },
        qmd = { "quarto", "md", "markdown" },
        rmarkdown = { "markdown" },
      },
      search_paths = { vim.env.HOME .. "/dev/snippets" },
    },
  },
}