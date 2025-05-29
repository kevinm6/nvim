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
    table.insert(items, { text = key, preview = value })
  end
  return items
end

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

local function show_environment_variables(_)
  local has_snacks, snacks = pcall(require, "snacks")
  if not has_snacks then
    vim.print(prepare_environment_variables())
    return
  end
  snacks.picker.pick {
    source = "Environment Variables",
    -- title = "Software licenses",
    items = prepare_environment_variables(),
    format = "text",
    preview = function(ctx)
      ctx.preview:set_lines { ctx.item.text, "", ctx.item.preview }
    end,
    -- TODO add copy-value to clipboard registry
    -- confirm = function(picker, item)
    --   local lines = split(item.preview)
    --   picker.close(picker)
    --   vim.api.nvim_put(lines, "l", false, true)
    -- end,
    actions = {
      add_environment_var = function(picker)
        vim.print(picker)
        print "called add var"
      end,
      edit_environment_var = function(picker)
        vim.print(picker)
        print "called edit var"
      end,
    },
    win = {
      input = {
        keys = {
          ["<a-e>"] = { "edit_environment_var", mode = { "n", "i" }, desc = "Edit Environment variable" },
          ["<a-a>"] = { "add_environment_var", mode = { "n", "i" }, desc = "Add Environment variable" },
        },
      },
    },
  }
end

function env.show_vars()
  show_environment_variables()
end

return env