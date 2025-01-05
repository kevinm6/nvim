-------------------------------------
--  File         : env.lua
--  Description  : environment variables in telescope or listed
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 13:22
-------------------------------------

local env = {}

local function prepare_environment_variables()
  local items = {}
  for key, value in pairs(vim.fn.environ()) do
    table.insert(items, { key, value })
  end
  return items
end

local conf = require("telescope.config").values

local function append_environment_name(prompt_bufnr)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if selection.value == "" then
    return
  end
  if vim.api.nvim_get_option_value("modifiable", { buf = 0 }) then
    vim.api.nvim_put({ selection.value[1] }, "b", true, true)
  end
end

local function append_environment_value(prompt_bufnr)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  if selection.value == "" then
    return
  end
  if vim.api.nvim_get_option_value("modifiable", { buf = 0 }) then
    vim.api.nvim_put({ selection.value[2] }, "b", true, true)
  end
end

local function edit_environment_value(prompt_bufnr)
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  vim.ui.input({
    prompt = "[ENV] Enter new value: ",
    default = selection.value[2],
  }, function(input)
    if not input then
      return
    end
    vim.notify("Set ENV var\n %s=%s", selection.value[1], input)
    -- Only works for the current session
    vim.fn.setenv(selection.value[1], input)
  end)
end

local function show_environment_variables(opts)
  local has_tele, pickers = pcall(require, "telescope.pickers")
  if not has_tele then
    vim.print(prepare_environment_variables())
    return
  end

  local finders = require "telescope.finders"
  local actions = require "telescope.actions"

  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Environment Variables",
      finder = finders.new_table {
        results = prepare_environment_variables(),
        entry_maker = function(entry)
          local columns = vim.o.columns
          local width = conf.width
            or conf.layout_config.width
            or conf.layout_config[conf.layout_strategy].width
            or columns
          local telescope_width
          if width > 1 then
            telescope_width = width
          else
            telescope_width = math.floor(columns * width)
          end
          local env_name_width = math.floor(columns * 0.05)
          local env_value_width = 22

          local entry_display = require "telescope.pickers.entry_display"
          -- NOTE: the width calculating logic is not exact, but approx enough
          local displayer = entry_display.create {
            separator = " ▏",
            items = {
              { width = env_value_width },
              { width = telescope_width - env_name_width - env_value_width },
              { remaining = true },
            },
          }

          local function make_display()
            -- concatenating multiline env values
            local concatenated_width = entry[2]:gsub("\r?\n", " ")
            return displayer {
              { entry[1] },
              { concatenated_width },
            }
          end

          return {
            value = entry,
            display = make_display,
            ordinal = string.format("%s %s", entry[1], entry[2]),
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_, map)
        actions.select_default:replace(append_environment_name)
        map("i", "<c-a>", append_environment_value)
        map("i", "<c-e>", edit_environment_value)
        return true
      end,
    })
    :find()
end

function env.show_vars()
  show_environment_variables()
end

return env
