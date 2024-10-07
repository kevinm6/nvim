-------------------------------------
-- File         : oil.lua
-- Description  : oil plugin config
-- Author       : Kevin
-- Last Modified: 09 May 2024, 17:51
-------------------------------------

---- Get defaults columns view
---@param detailed boolean if true get the detailed view, compact otherwise
local function default_coloumns(detailed)
  return detailed
      and {
        { "permissions", highlight = "String" },
        { "mtime", highlight = "Comment" },
        { "size", highlight = "Type" },
        "icon",
      }
    or { "icon" }
end

return {
  "stevearc/oil.nvim",
  keys = {
    {
      "<leader>E",
      function()
        require("oil").open()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>e",
      function()
        require("oil").toggle_float()
      end,
      desc = "File Browser",
    },
    {
      "<leader>fb",
      function()
        require("oil").toggle_float(vim.uv.cwd() or vim.fn.expand "%:p:h")
      end,
      desc = "File Browser (CWD)",
    },
  },
  cmd = "Oil",
  opts = {
    columns = default_coloumns(true),
    keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-k>"] = "k",
      ["<C-j>"] = "j",
      ["<C-l>"] = "actions.select",
      ["<C-s>"] = "actions.select_split",
      ["<C-a-s>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
      ["<M-p>"] = "actions.preview",
      ["<M-o>"] = {
        desc = "View File",
        callback = function()
          local dir = require("oil").get_current_dir()
          local file = require("oil").get_cursor_entry().name
          if not dir or not file then
            return
          end
          require("oil").close() -- avoid that opens file in Oil window
          vim.cmd.view(dir .. file)
        end,
      },
      ["<C-o>"] = "actions.open_external",
      ["<C-\\>"] = "actions.open_terminal",
      ["<C-c>"] = "actions.close",
      ["gh"] = {
        desc = "Open UserDir",
        callback = function()
          require("oil").close()
          local home_dir = tostring(vim.env.HOME)
          require("oil").open_float(home_dir)
        end,
      },
      ["q"] = "actions.close",
      ["<Esc><Esc>"] = "actions.close",
      ["<C-h>"] = "actions.parent",
      ["<C-.>"] = "actions.toggle_hidden",
      ["g."] = "actions.toggle_hidden",
      ["-"] = "actions.parent",
      ["gw"] = "actions.open_cwd",
      ["<leader>."] = "actions.cd",
      ["gt"] = "actions.toggle_trash",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["yp"] = "actions.copy_entry_path",
      ["g:"] = "actions.open_cmdline",
      ["gr"] = "actions.refresh",
      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          local config = require "oil.config"
          if #config.columns == #default_coloumns(false) then
            require("oil").set_columns(default_coloumns(true))
          else
            require("oil").set_columns(default_coloumns(false))
          end
        end,
      },
    },
    constrain_cursor = "name",
    use_default_keymaps = false,
    skip_confirm_for_simple_edits = true,
    silence_scp_warning = true, -- disable scp warn to use oil-ssh since I'm using a remap
    view_options = {
      is_always_hidden = function(name, _)
        local ft_to_exclude = {
          [".DS_Store"] = true,
          ["Icon\r"] = true,
        }
        return ft_to_exclude[name]
      end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 0,
      max_width = 0,
      max_height = 16,
      border = "rounded",
      win_options = {
        winblend = 3,
      },
      override = function(conf)
        conf.row = (vim.o.lines - conf.height - 3)
        return conf
      end,
    },

    progress = {
      win_options = {
        winblend = 8,
      },
    },
    -- HACK Using this to remap url-scheme from args with oil-ssh schemes
    -- https://github.com/stevearc/oil.nvim/blob/master/lua/oil/config.lua#L187
    adapter_aliases = {
      ["ssh://"] = "oil-ssh://",
      ["scp://"] = "oil-ssh://",
      ["sftp://"] = "oil-ssh://",
    },
  },
  init = function(p)
    if vim.fn.argc() == 1 then
      local argv = tostring(vim.fn.argv(0))
      local stat = vim.loop.fs_stat(argv)

      local remote_dir_args = vim.startswith(argv, "ssh") or vim.startswith(argv, "sftp") or vim.startswith(argv, "scp")

      if stat and stat.type == "directory" or remote_dir_args then
        require("lazy").load { plugins = { p.name } }
      end
    end
    if not require("lazy.core.config").plugins[p.name]._.loaded then
      vim.api.nvim_create_autocmd("BufNew", {
        pattern = "*/", -- load on dirs
        callback = function()
          require("lazy").load { plugins = { p.name } }
          return true
        end,
      })
    end
  end,
}