-------------------------------------
--  File         : obsidian.lua
--  Description  : obsidian notes plugin setup
--  Author       : Kevin
--  Last Modified: 16 Jul 2023, 11:58
-------------------------------------

local M = {
   "epwalsh/obsidian.nvim",
   event = {
      "BufReadPre /Users/Kevin/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/**/*.md",
   },
   dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
   },
   opts = function(_, o)
      o.dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents"
      o.notes_subdir = "notes"
      o.log_level = vim.log.levels.DEBUG

      o.daily_notes = {
         folder = "notes/daily",
         date_format = "%d-%m-%Y",
      }
      o.completion = {
         nvim_cmp = true,
         min_chars = 2,
         new_notes_location = "current_dir",
      }
      o.disable_frontmatter = false

      o.templates = {
         subdir = "notes/templates",
         date_format = "%a %d-%m-%Y",
         time_format = "%H:%M",
      }

      o.follow_url_func = function(url)
         vim.fn.jobstart { "open", url } -- mac os
      end

      o.use_advanced_uri = true

      o.open_app_foreground = false

      o.finder = "telescope.nvim"
   end,
   config = function(_, o)
      require("obsidian").setup(o)

      vim.keymap.set("n", "gf", function()
         if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>ObsidianFollowLink<CR>"
         else
            return "gf"
         end
      end, { noremap = false, expr = true })

      vim.keymap.set("n", "<leader>oO", function()
         vim.cmd.ObsidianOpen()
      end, { desc = "ObsidianOpen" })

      vim.keymap.set("n", "<leader>ot", function()
         vim.cmd.ObsidianTemplate()
      end, { desc = "ObsidianTemplate" })

      vim.keymap.set("n", "<leader>oT", function()
         vim.cmd.ObsidianToday()
      end, { desc = "Obsidian Today" })

      vim.keymap.set("n", "<leader>oY", function()
         vim.cmd.ObsidianYesterday()
      end, { desc = "Obsidian Yesterday" })

      vim.keymap.set("v", "<leader>ob", function()
         vim.cmd.ObsidianBacklinks()
      end, { desc = "ObsidianBacklinks" })

      vim.keymap.set("v", "<leader>ol", function()
         vim.cmd "ObsidianLink "
      end, { desc = "Obsidian Link" })

      vim.keymap.set("v", "<leader>oL", function()
         vim.cmd "ObsidianLinkNew "
      end, { desc = "ObsidianLink New Note" })

      vim.api.nvim_create_autocmd("BufEnter", {
         group = vim.api.nvim_create_augroup("_obsidian", {}),
         pattern = "/Users/Kevin/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/**/*.md",
         callback = function()
            vim.cmd [[
               syntax match mkdToDo '\v(\s+)?-\s\[\s\]'hs=e-4 conceal cchar=☐
               syntax match mkdToDoDone '\v(\s+)?-\s\[x\]'hs=e-4 conceal cchar=
               syntax match mkdToDoSkip '\v(\s+)?-\s\[\~\]'hs=e-4 conceal cchar=
               syntax match mkdToDoQuestion '\v(\s+)?-\s\[\?\]'hs=e-4 conceal cchar=‽
               syntax match mkdToDoFollowup '\v(\s+)?-\s\[\>\]'hs=e-4 conceal cchar=⇨
            ]]
         end,
      })
   end,
}

return M
