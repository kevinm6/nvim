-------------------------------------
--  File         : env.lua
--  Description  : environment variables in telescope or listed
--  Author       : Kevin
--  Last Modified: 28 Dec 2025, 17:20
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
  local buf = vim.api.nvim_get_current_buf()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  snacks.picker.pick {
    source = "Environment Variables",
    items = get_environment_variables(),
    format = "text",
    preview = function(ctx)
      ctx.preview:set_lines { ctx.item.text, "", ctx.item.preview }
    end,
    confirm = function(picker, item)
      local value = item.preview
      picker:close()
      vim.api.nvim_buf_set_lines(buf, cur_line, -1, false, { value })
    end,
    actions = {
      copy_to_clipboard = function(picker, item)
        vim.fn.setreg("+", item.preview)
        picker:close()
        vim.notify(string.format("Env - var < %s > value copied to clipboard", item.text), vim.log.levels.INFO, { title = "Env" })
      end,
      add_environment_var = function(picker, item)
        local prompt = string.format("Env - enter new env var in 'VAR=VALUE' format: ")
        picker:close()
        vim.ui.input({ prompt = prompt, default = item.preview }, function(input)
          if input then
            local new_var, new_value = unpack(vim.split(input, "="))
            vim.env[new_var] = tostring(new_value)
            local msg = string.format("Env - set env var '%s' to '%s'", new_var, new_value)
            vim.notify(msg, vim.log.levels.INFO, { title = "Env" })
          end
        end)
      end,
      edit_environment_var = function(picker)
        if picker:current().text == "" then return end
        local c_word = picker:current().text
        local prompt = string.format("Env - enter new value for < %s > : ", c_word)
        picker:close()
        vim.ui.input({ prompt = prompt }, function(input)
          if input then
            vim.env[c_word] = tostring(input)
            local msg = string.format("Env - update env var '%s' to '%s'", c_word, input)
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
          ["<a-y>"] = { "copy_to_clipboard", mode = { "n", "i" }, desc = "Copy to system clipboard" },
          ["<C-y>"] = { "copy_to_clipboard", mode = { "n", "i" }, desc = "Copy to system clipboard" },
          ["yy"] = { "copy_to_clipboard", mode = { "n" }, desc = "Copy to system clipboard" },
        },
      },
    },
  }
end

function M.show_vars()
  show_environment_variables()
end

return M