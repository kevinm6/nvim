-------------------------------------
--  File         : telescope.lua
--  Description  : telescope utility functions
--  Author       : Kevin
--  Last Modified: 13 Aug 2024, 08:54
-------------------------------------

local M = {}

function M.select_one_or_multi(prompt_bufnr, action)
  local tele_actions = require "telescope.actions"
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require("telescope.actions").close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format("%s %s", action, j.path))
      end
    end
  else
    local action_map = {
      edit = tele_actions.select_default,
      sp = tele_actions.select_horizontal,
      vsp = tele_actions.select_vertical,
      tabe = tele_actions.select_tab,
    }
    if not action_map[action] then
      vim.notify("action passed not found: " .. action)
      return
    end

    action_map[action](prompt_bufnr)
  end
end

return M
