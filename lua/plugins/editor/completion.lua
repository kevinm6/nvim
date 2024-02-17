-------------------------------------
-- File         : cmp.lua
-- Description  : Lua K NeoVim & VimR cmp config
-- Author       : Kevin
-- Last Modified: 03 Dec 2023, 10:47
-------------------------------------


local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        { "kevinm6/the-snippets", dev = true },
        -- "rafamadriz/friendly-snippets",
      },
      -- Luasnip Configuration
      opts = function(_, o)
        o.history = true
        o.updateevents = "TextChanged, TextChangedI"
        o.delete_check_events = "TextChanged, InsertEnter"
        o.enable_autosnippets = true
        o.exet_prio_increase = 1
      end,
      config = function(_, opts)
        -- Sources for snippets
        if opts then require("luasnip").config.setup(opts) end
        vim.tbl_map(
          function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
          { "vscode", "lua" }
        )
        require("luasnip").filetype_extend("typescript", { "tsdoc" })
        require("luasnip").filetype_extend("javascript", { "jsdoc" })
        require("luasnip").filetype_extend("lua", { "luadoc" })
        require("luasnip").filetype_extend("python", { "python-docstring" })
        require("luasnip").filetype_extend("rust", { "rustdoc" })
        require("luasnip").filetype_extend("cs", { "csharpdoc" })
        require("luasnip").filetype_extend("java", { "javadoc" })
        require("luasnip").filetype_extend("sh", { "shelldoc" })
        require("luasnip").filetype_extend("c", { "cdoc" })
        require("luasnip").filetype_extend("cpp", { "cppdoc" })
        require("luasnip").filetype_extend("php", { "phpdoc" })
        require("luasnip").filetype_extend("kotlin", { "kdoc" })
        require("luasnip").filetype_extend("ruby", { "rdoc" })
        require("luasnip").filetype_extend("quarto", { "markdown" })
        require("luasnip").filetype_extend("rmarkdown", { "markdown" })
      end,
    },
    "hrsh7th/cmp-buffer",
    { "rcarriga/cmp-dap", ft = { "dap-repl", "dapui_watches", "dapui_hover" } },
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    { "kdheepak/cmp-latex-symbols", ft = "markdown" },
    {
      "kristijanhusak/vim-dadbod-completion",
      ft = { "sql", "mysql", "plsql" },
      enabled = false,
    }
    -- "hrsh7th/cmp-nvim-lua",
    -- "ray-x/cmp-treesitter",
  },
  opts = function(_, o)
    local cmp = require "cmp"
    local ls = require "luasnip"
    local icons = require "lib.icons"
    local icons_kind = icons.kind
    local context = require "cmp.config.context"

    o.snippet = {
      expand = function(args)
        ls.lsp_expand(args.body)
      end
    }

    -- TODO: update for nvim-0.1.0 removing deprecated code
    o.enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require "cmp_dap".is_dap_buffer()
    end

    o.mapping = {
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),

      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),

      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-3), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(3), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },

      ["<C-l>"] = cmp.mapping(function(fallback)
        if cmp.visible() and not cmp.get_active_entry() then
          return cmp.complete_common_string()
        elseif cmp.visible() and cmp.get_active_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        elseif ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        else
          fallback()
        end
      end),

      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      }),

      ["<M-CR>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),

      ["<Right>"] = cmp.mapping.confirm { select = true },

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

      ['<C-g>'] = function()
        if cmp.visible_docs() then
          cmp.close_docs()
        else
          cmp.open_docs()
        end
      end,

      ["<C-i>"] = cmp.mapping(function(fallback)
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
    }

    o.formatting = {
      fields = { "abbr", "kind", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s %s", icons_kind[vim_item.kind], vim_item
          .kind)

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          luasnip = '[Snip]',
          nvim_lua = '[NvLua]',
          buffer = '[Buf]',
          -- treesitter = '[TS]',
        })[entry.source.name]

        vim_item.dup = ({
          luasnip = 1,
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
        filter = function(_, _)
          return not context.in_syntax_group "Comment"
            or not context.in_treesitter_capture "comment"
        end,
      },
      { name = "otter" },
      {
        name = "buffer",
        option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
      },
      {
        name = "luasnip",
        filter = function(_, _)
          return not context.in_syntax_group "Comment"
            or not context.in_treesitter_capture "comment"
        end,
      },
      { name = "nvim_lua" },
      { name = "treesitter" },
      { name = "path",          option = { trailing_slash = true } },
      { name = "latex_symbols", keyword_length = 2,                priority = 2 },
      { name = "calc",          keyword_length = 3 },
    }

    o.confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }

    o.window = {
      completion = cmp.config.window.bordered({ scrollbar = false }),
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
    cmp.setup.filetype({ "markdown", "latex", "text", "quarto" }, {
      sources = cmp.config.sources {
        { name = "otter" },
        {
          name = "buffer",
          option = { keyword_length = 4, keyword_pattern = [[\k\+]] },
        },
        { name = "treesitter" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path",          option = { trailing_slash = true } },
        { name = "latex_symbols", keyword_length = 3 },
        { name = "calc",          keyword_length = 3 },
      },
    })

    cmp.setup.filetype("help", {
      window = {
        documentation = cmp.config.disable,
      },
    })

    cmp.setup.cmdline("/", {
      autocomplete = { cmp.TriggerEvent.TextChanged },
      sources = cmp.config.sources({
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline(':', {
      autocomplete = { cmp.TriggerEvent.TextChanged },
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path', option = { trailing_slash = true } },
      }, {
          { name = 'cmdline', length = 3 }
        })
    })

    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = {
        -- { name = "vim-dadbod-completion" },
        { name = "treesitter" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
      }
    })

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })

    cmp.setup(o)
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end
}

return M