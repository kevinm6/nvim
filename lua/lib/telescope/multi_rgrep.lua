-------------------------------------
--  File         : multi_rgrep.lua
--  Description  : telescope utility function
--  Author       : Kevin
--  Last Modified: 13/12/2024 - 18:40
-------------------------------------

local M = {}

local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

-- i would like to be able to do telescope
-- and have telescope do some filtering on files and some grepping

local function live_multigrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local prompt_split = vim.split(prompt, "  ")
      local args = { "rg" }

      if prompt_split[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      end

      if prompt_split[2] then
        table.insert(args, "-g")
        table.insert(args, prompt_split[2])
      end

      return vim
        .iter({
          args,
          { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Live Grep (with shortcuts)",
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

M.run = function(opts)
  live_multigrep(opts)
end

return M
