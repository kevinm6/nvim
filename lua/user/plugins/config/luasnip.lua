-------------------------------------
--  File         : luasnip.lua
--  Description  : luasnip configuration
--  Author       : Kevin
--  Last Modified: 17 Jul 2022, 10:35
-------------------------------------

local ok, ls = pcall(require, "luasnip")
if not ok then return end

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
local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.expand_conditions")
-- local lambda = require("luasnip.extras").l

-- Luasnip Configuration
ls.config.set_config {
	history = true,
	updateevents = "TextChanged, TextChangedI",
	delete_check_events = "TextChanged, InsertEnter",
  enable_autosnippets = true,
  exet_prio_increase = 1,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = {{"●", "LuasnipChoiceNode" }}
			}
		},
		[types.insertNode] = {
			active = {
				virt_text = {{"●", "LuasnipInsertNode" }}
			}
		}
	},
}

-- ls.add_snippets("lua", {
--   s(
--     "req",
--     fmt([[local {} = require("{}")]], { i(1), rep(1), })
--   ),
-- })

-- Sources for snippets
require("luasnip.loaders.from_vscode").lazy_load()

