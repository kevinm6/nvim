-------------------------------------
--  File         : pick_license.lua
--  Description  : helper module to get licenses
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 14:01
-------------------------------------

local M = {}

-- Software Licenses
--    @type <table>
--    @param telescope options
function M.pick_license(telescope_opts)
   local pickers = require "telescope.pickers"
   local finders = require "telescope.finders"
   local conf = require("telescope.config").values
   local actions = require "telescope.actions"
   local action_state = require "telescope.actions.state"
   local previewers = require "telescope.previewers"
   local results = {}

   local function split(s, sep)
      sep = sep or "\n"
      local fields = {}
      local pattern = string.format("([^%s]+)", sep)
      for match, _ in string.gmatch(s, pattern) do
         table.insert(fields, match)
      end
      return fields
   end

   local licenses = require "lib.software_licenses.licenses"
   for _, license in ipairs(licenses) do
      local name = license.name
      local text = split(license.text)
      table.insert(results, { name, text })
   end

   telescope_opts = vim.tbl_extend(
      "keep",
      telescope_opts or {},
      require("telescope.themes").get_dropdown { preview = { hide_on_startup = true }}
   )
   pickers
       .new(telescope_opts, {
          prompt_title = "Software Licenses",
          finder = finders.new_table {
             results = results,
             entry_maker = function(entry)
                return { value = entry, display = entry[1], ordinal = entry[1] }
             end,
          },
          sorter = conf.generic_sorter(telescope_opts),
          attach_mappings = function(prompt_bufnr, _)
             actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_put(selection.value[2], "l", false, true)
             end)
             return true
          end,
          previewer = previewers.new_buffer_previewer {
             define_preview = function(self, entry)
                local output = entry.value[2]
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
             end,
          },
       })
       :find()
end

return M