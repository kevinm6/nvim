-------------------------------------
--  File         : env.lua
--  Description  : environment variables in telescope or listed
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 13:22
-------------------------------------

local M = {}

local function get_environment_variables()
  local items = {}
  for key, value in pairs(vim.fn.environ()) do
    table.insert(items, { text = key, preview = value })
  end
  return items
end

local function show_environment_variables(_)
  local has_snacks, snacks = pcall(require, "snacks")
  if not has_snacks then
    vim.fn.setloclist(0, get_environment_variables(), ' ')
    return
  end
  snacks.picker.pick {
    source = "Environment Variables",
    items = get_environment_variables(),
    format = "text",
    preview = function(ctx)
      ctx.preview:set_lines { ctx.item.text, "", ctx.item.preview }
    end,
    confirm = function(picker, item)
      vim.fn.setreg("+", item.preview)
      picker:close()
      vim.notify(string.format("Env var < %s > value copied to clipboard", item.text), vim.log.levels.INFO, { title = "Env" })
    end,
    actions = {
      add_environment_var = function(picker)
        local prompt = string.format("Enter new env var in 'VAR=VALUE' format: ")
        picker:close()
        vim.ui.input({ prompt = prompt }, function(input)
          if input then
            local new_var, new_value = unpack(vim.split(input, "="))
            vim.env[new_var] = tostring(new_value)
            local msg = string.format("Set env var '%s' to '%s'", new_var, new_value)
            vim.notify(msg, vim.log.levels.INFO, { title = "Env" })
          end
        end)
      end,
      edit_environment_var = function(picker)
        if picker:current().text == "" then return end
        local c_word = picker:current().text
        local prompt = string.format("Enter new value for < %s > : ", c_word)
        picker:close()
        vim.ui.input({ prompt = prompt }, function(input)
          if input then
            vim.env[c_word] = tostring(input)
            local msg = string.format("Update env var '%s' to '%s'", c_word, input)
            vim.notify(msg, vim.log.levels.INFO, { title = "Env" })
          end
        end)
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

function M.show_vars()
  show_environment_variables()
end

return M