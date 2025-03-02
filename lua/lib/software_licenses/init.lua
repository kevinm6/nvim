-------------------------------------
--  File         : pick_license.lua
--  Description  : helper module to get licenses
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 14:01
-------------------------------------

local M = {}

local function split(s, sep)
  sep = sep or "\n"
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  for match, _ in string.gmatch(s, pattern) do
    table.insert(fields, match)
  end
  return fields
end

---Get licenses
---@return table licenses
local function get_licenses()
  local licenses = require "lib.software_licenses.licenses"
  return licenses
end

---Software Licenses
function M.pick_license()
  local has_snacks, snacks = pcall(require, "snacks")

  if not has_snacks then
    vim.ui.select(get_licenses(), {
      prompt = "Software Licenses",
      desc = "Select License",
    }, function(item)
      if choice == "spaces" then
        local lines = split(item.preview)
        vim.api.nvim_put(lines, "l", false, true)
      end
    end)
  else
    require("snacks").picker.pick {
      source = "Software Licenses",
      -- title = "Software licenses",
      items = get_licenses(),
      format = "text",
      preview = function(ctx)
        ctx.preview:set_lines { ctx.item.preview }
      end,
      confirm = function(picker, item)
        local lines = split(item.preview)
        picker.close(picker)
        vim.api.nvim_put(lines, "l", false, true)
      end,
    }
  end
end

return M
