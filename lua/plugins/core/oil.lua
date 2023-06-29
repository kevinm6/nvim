-------------------------------------
-- File         : oil.lua
-- Description  : oil plugin config
-- Author       : Kevin
-- Last Modified: 02 Jul 2023, 10:49
-------------------------------------

local M = {
  "stevearc/oil.nvim",
  keys = {
    { "<leader>E", function() require "oil".open() end, desc = "[Oil] Open parent dir" },
    { "<leader>O", function() require "oil".open_float() end, desc = "[Oil] Open float" }
  },
  cmd = "Oil",
  opts = function(_, o)
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    o.columns = {
      { "permissions", highlight = "String" },
      { "mtime", highlight = "Comment" },
      { "size", highlight = "Type" },
      "icon",
    }
    --- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    --- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
    --- Additionally, if it is a string that matches "action.<name>",
    --- it will use the mapping at require("oil.action").<name>
    --- Set to `false` to remove a keymap
    o.keymaps = {
      ["?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-k>"] = "k",
      ["<C-j>"] = "j",
      ["<C-l>"] = "actions.select",
      ["<C-s>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["q"] = "actions.close",
      ["<C-h>"] = "actions.parent",
      ["<C-.>"] = "actions.toggle_hidden",
      ["g."] = "actions.toggle_hidden",
      ["<C-t>"] = "actions.open_terminal",
      ["-"] = "actions.parent",
      ["<C-g>"] = "actions.open_cwd",
      ["<C-x>"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gd"] = {
        desc = "Toggle detail view",
        callback = function()
          local oil = require("oil")
          local config = require("oil.config")
          if #config.columns == 1 then
            oil.set_columns({ "icon", "permissions", "size", "mtime" })
          else
            oil.set_columns({ "icon" })
          end
        end,
      },
    }
      o.use_default_keymaps = false
    o.silence_scp_warning = true -- disable scp warn to use oil-ssh since I'm using a remap
    o.view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
      is_hidden_file = function (name, bufnr)
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function (name, bufnr)
        return false
      end
    }
    -- Configuration for the floating window in oil.open_float
    o.float = {
      -- Padding around the floating window
      padding = 10,
      max_width = 0,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    }
    -- This are defaults for now, no need to override
    -- adapters = {
    --   ["oil://"] = "files",
    --   ["oil-ssh://"] = "ssh",
    -- },
    -- When opening the parent of a file, substitute these url schemes
    -- HACK:
    -- https://github.com/stevearc/oil.nvim/blob/931453fc09085c09537295c991c66637869e97e1/lua/oil/config.lua#L102~110
    -- Using this to remap url-scheme from args with oil-ssh schemes
    o.adapter_aliases = {
      ["ssh://"] = "oil-ssh://",
      ["scp://"] = "oil-ssh://",
      ["sftp://"] = "oil-ssh://",
    }
end,
  init = function(p)
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      local remote_dir_args = vim.startswith(vim.fn.argv(0), "ssh") or
        vim.startswith(vim.fn.argv(0), "sftp") or vim.startswith(vim.fn.argv(0), "scp")
      if stat and stat.type == "directory" or remote_dir_args then
        require("lazy").load { plugins = { p.name } }
      end
    end
    if not require("lazy.core.config").plugins[p.name]._.loaded then
      vim.api.nvim_create_autocmd("BufNew", {
        callback = function()
          if vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
            require("lazy").load { plugins = { "oil.nvim" } }
            -- Once oil is loaded, we can delete this autocmd
            return true
          end
        end,
      })
    end
  end
}

return M
