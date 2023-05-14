-------------------------------------
--  File         : luasnip.lua
--  Description  : luasnip configuration
--  Author       : Kevin
--  Last Modified: 13 May 2023, 11:21
-------------------------------------

local M = {
  "L3MON4D3/LuaSnip",
  -- config = function ()
    -- local ls = require "luasnip"
    -- local s = ls.snippet
    -- local t = ls.text_node
    -- local i = ls.insert_node
    -- local sn = ls.snippet_node
    -- local f = ls.function_node
    -- local c = ls.choice_node
    -- local d = ls.dynamic_node
    -- local r = ls.restore_node
    -- local l = require("luasnip.extras").lambda
    -- local rep = require("luasnip.extras").rep
    -- local p = require("luasnip.extras").partial
    -- local m = require("luasnip.extras").match
    -- local n = require("luasnip.extras").nonempty
    -- local dl = require("luasnip.extras").dynamic_lambda
    -- local fmt = require("luasnip.extras.fmt").fmt
    -- local fmta = require("luasnip.extras.fmt").fmta
    -- local types = require("luasnip.util.types")
    -- local conds = require("luasnip.extras.expand_conditions")
    -- local lambda = require("luasnip.extras").l

  -- Luasnip Configuration
    opts = function(_, o)
      o.history = true
      o.updateevents = "TextChanged, TextChangedI"
      o.delete_check_events = "TextChanged, InsertEnter"
      o.enable_autosnippets = true
      o.exet_prio_increase = 1
      -- ext_opts = {
      --   [types.choiceNode] = {
      --     active = {
      --       virt_text = {{"●", "LuasnipChoiceNode" }}
      --     }
      --   },
      --   [types.insertNode] = {
      --     active = {
      --       virt_text = {{"●", "LuasnipInsertNode" }}
      --     }
      --   }
      -- },
   end,

    -- ls.add_snippets("lua", {
    --   s(
    --     "req",
    --     fmt([[local {} = require("{}")]], { i(1), rep(1), })
    --   ),
    -- })

    -- Sources for snippets
  config = function()
    require "luasnip.loaders.from_vscode".lazy_load()
  end
}

return M
