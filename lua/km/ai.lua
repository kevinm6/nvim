-------------------------------------
--  File         : ai.lua
--  Description  : AI interops with Neovim
--  Author       : Kevin
--  Last Modified: 25 Jan 2026, 10:27
-------------------------------------

require("minuet").setup {
  provider = "openai_fim_compatible",
  n_completions = 1,
  context_window = 512,
  provider_options = {
    openai_fim_compatible = {
      api_key = "TERM",
      name = "Ollama",
      end_point = "http://localhost:11434/v1/completions",
      model = "qwen2.5-coder:7b",
      optional = {
        max_tokens = 56,
        top_p = 0.9
      }
    }
  },
  completion = {
    enable = true,
    -- blink = {
    --   enable = true,
    --   source_name = "minuet",
    --   priority = -10,
    --   max_items = 1,
    --   -- score_offset = 50,
    -- }
  },
  virtualtext = {
    keymap = {
      accept = '<M-A>',                 -- accept whole completion
      accept_line = '<M-l>',            -- accept one line
      -- e.g. "A-z 2 CR" will accept 2 lines
      accept_n_lines = '<M-z>',         -- accept n lines (prompts for number)
      prev = '<M-C-è>',                 -- Cycle to prev completion item, or manually invoke completion
      next = '<M-C-+>',                 -- Cycle to next completion item, or manually invoke completion
      dismiss = '<M-e>',
    },
  },
}

local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  local blink_config = require "blink.cmp.config"

  pcall(blink.add_source_provider, "minuet", {
    enabled = true,
    name = 'minuet',
    module = 'minuet.blink',
    async = true,
    timeout_ms = 3000,
    score_offset = 100,
  })
  ---NOTE: without this, is not showing by default on autocomplete
  blink_config.sources.default = vim.list_extend(blink_config.sources.default, { "minuet" })
  -- Recommended to avoid unnecessary request
  -- blink.completion.trigger.prefetch_on_insert = false
end

vim.keymap.set("i", "<M-l>", function()
  require("minuet").make_blink_map()
end, { desc = "AI Smart Completion" })