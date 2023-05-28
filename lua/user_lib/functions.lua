-------------------------------------
--  File         : functions.lua
--  Description  : various utilities functions
--  Author       : Kevin
--  Last Modified: 28 May 2023, 14:04
-------------------------------------

local F = {}

F.sniprun_enable = function()
   vim.cmd [[
    %SnipRun

    augroup _sniprun
    autocmd!
    autocmd TextChanged * call Test()
    autocmd TextChangedI * call TestI()
    augroup end
    ]]
   vim.notify "Enabled SnipRun"
end

F.disable_sniprun = function()
   F.remove_augroup "_sniprun"
   vim.cmd [[
    SnipClose
    SnipTerminate
    ]]
   vim.notify "Disabled SnipRun"
end

F.toggle_sniprun = function()
   if vim.fn.exists "#_sniprun#TextChanged" == 0 then
      F.sniprun_enable()
   else
      F.disable_sniprun()
   end
end

F.remove_augroup = function(name)
   if vim.fn.exists("#" .. name) == 1 then
      vim.cmd("au! " .. name)
   end
end

-- get length of current word
F.get_word_length = function()
   local word = vim.fn.expand "<cword>"
   return #word
end

F.toggle_option = function(option)
   local value = not vim.api.nvim_get_option_value(option, {})
   vim.opt[option] = value
   vim.notify(option .. " set to " .. tostring(value))
end

F.toggle_tabline = function()
   local value = vim.api.nvim_get_option_value("showtabline", {})

   if value == 2 then
      value = 0
   else
      value = 2
   end

   vim.opt.showtabline = value

   vim.notify("showtabline" .. " set to " .. tostring(value))
end

local diagnostics_active = true
F.toggle_diagnostics = function()
   diagnostics_active = not diagnostics_active
   if diagnostics_active then
      vim.diagnostic.show()
   else
      vim.diagnostic.hide()
   end
end

-- Dev FOLDER
F.dev_folder = function()
   local dev_folders = {
      vim.fn.expand "~/dev",
      vim.fn.expand "~/Documents/developer",
   }
   require "telescope"
   vim.ui.select(dev_folders, {
      prompt = " > Select dev folder",
      default = nil,
   }, function(choice)
      if choice then
         require("telescope").extensions.file_browser.file_browser { cwd = choice }
      end
   end)
end

-- SESSIONS
local get_sessions = function()
   local sessions = {}

   local sessions_data_stdpath = vim.fn.stdpath "data" .. "/sessions"
   local sessions_files = vim.split(vim.fn.globpath(sessions_data_stdpath, "*.vim"), "\n", { trimempty = true })

   for _, f in pairs(sessions_files) do
      table.insert(sessions, f)
   end
   return sessions
end

F.delete_session = function()
   local sessions = get_sessions()

   if #sessions >= 1 then
      require "telescope"
      vim.ui.select(sessions, {
         prompt = "Select session to delete:",
         default = nil,
      }, function(choice)
         if choice then
            vim.fn.jobstart("mv " .. vim.fn.fnameescape(choice) .. " ~/.Trash", {
               detach = true,
               on_exit = function()
                  vim.notify(("Session < %s > deleted!"):format(choice), vim.log.levels.WARN)
               end,
            })
         end
      end)
   else
      vim.notify("No Sessions to delete", vim.log.levels.WARN)
   end
end

F.restore_session = function()
   local sessions = get_sessions()

   if #sessions >= 1 then
      require "telescope"
      vim.ui.select(sessions, {
         prompt = " > Select session to restore",
         default = nil,
      }, function(choice)
         local s_name = vim.fn.fnamemodify(choice, ":p:t:r")
         if choice then
            vim.cmd.source(choice)
            require("core.statusline").session_name = s_name
            vim.notify(("Session < %s > restored!"):format(choice), vim.log.levels.INFO)
         end
      end)
   else
      vim.notify("No Sessions to restore", vim.log.levels.WARN)
   end
end

F.save_session = function()
   require "telescope"
   vim.ui.input({
      prompt = "Enter session name: ",
      default = nil,
   }, function(input)
      if input then
         local mks_path = vim.fn.stdpath "data" .. "/sessions/" .. input .. ".vim"
         vim.cmd("mksession! " .. mks_path)
         vim.notify(("Session < %s > created!"):format(input), vim.log.levels.INFO)
      end
   end)
end

-- END SESSIONS

F.align = function(pat)
   local top, bot = vim.fn.getpos "'<", vim.fn.getpos "'>"
   F.align_lines(pat, top[2] - 1, bot[2])
   vim.fn.setpos("'<", top)
   vim.fn.setpos("'>", bot)
end

F.align_lines = function(pat, startline, endline)
   local re = vim.regex(pat)
   if not pat or not re then
      vim.notify("Pattern for RegEx not valid", vim.log.levels.WARN)
      return
   end

   local max = -1
   local lines = vim.api.nvim_buf_get_lines(0, startline, endline, false)
   for _, line in pairs(lines) do
      local s = re:match_str(line)
      s = vim.str_utfindex(line, s)
      if s and max < s then
         max = s
      end
   end

   if max == -1 then
      return
   end

   for i, line in pairs(lines) do
      local s = vim.regex(pat):match_str(line)
      s = vim.str_utfindex(line, s)
      if s then
         local rep = max - s
         local newline = {
            string.sub(line, 1, s),
            string.rep(" ", rep),
            string.sub(line, s + 1),
         }
         lines[i] = table.concat(newline)
      end
   end

   vim.api.nvim_buf_set_lines(0, startline, endline, false, lines)
end

F.range_format = function()
   local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
   local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
   vim.lsp.buf.format {
      range = {
         ["start"] = { start_row, 0 },
         ["end"] = { end_row, 0 },
      },
      async = true,
   }
end

-- Use null-ls for lsp-formatting
F.lsp_format = function(bufnr)
   vim.lsp.buf.format {
      filter = function(client)
         return client.name == "null-ls"
      end,
      bufnr = bufnr,
   }
end

-- Format on save
F.format_on_save = function(buf, enable)
   local action = function()
      return enable and "Enabled" or "Disabled"
   end

   if enable then
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
         group = vim.api.nvim_create_augroup("_format_on_save", { clear = true }),
         pattern = "*",
         callback = function()
            F.lsp_format(buf)
         end,
      })
   else
      vim.api.nvim_clear_autocmds { group = "format_on_save" }
   end

   vim.notify(action() .. " format on save", vim.log.levels.INFO, { title = "LSP" })
end

F.toggle_format_on_save = function()
   if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
      F.format_on_save(true)
   else
      F.format_on_save()
   end
end

-- Create new file w/ input for filename
-- useful for dashboard and so on
F.new_file = function()
   vim.ui.input({
      prompt = "Enter name for newfile: ",
      default = nil,
   }, function(input)
      if input then
         vim.cmd.enew()
         vim.cmd.edit(input)
         vim.cmd.write(input)
         vim.cmd.startinsert()
      end
   end)
end

F.new_tmp_file = function()
   vim.ui.input({
      prompt = "Enter name for temp file: ",
      default = os.date "%d%m%Y_file_%H%M%S" .. ".",
   }, function(input)
      if input then
         vim.cmd.enew()
         vim.cmd.edit(input)
         vim.cmd.write(input)
         vim.cmd.startinsert()
      end
   end)
end

F.workon = function()
   require "telescope"
   local config = require "lazy.core.config"
   vim.ui.select(vim.tbl_values(config.plugins), {
      prompt = "lcd to:",
      format_item = function(plugin)
         return string.format("%s (%s)", plugin.name, plugin.dir)
      end,
   }, function(plugin)
      if not plugin then
         return
      end
      vim.schedule(function()
         vim.cmd.lcd(plugin.dir)
      end)
   end)
end

-- Software Licenses
F.software_licenses = function()
   local pickers = require "telescope.pickers"
   local finders = require "telescope.finders"
   local conf = require("telescope.config").values
   local actions = require "telescope.actions"
   local action_state = require "telescope.actions.state"
   local previewers = require "telescope.previewers"
   local licenses = require "user_lib.licenses"
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

   for _, license in ipairs(licenses) do
      local name = license.name
      local text = split(license.text)
      table.insert(results, { name, text })
   end

   local M = {}

   M.licenses = function(telescope_opts)
      telescope_opts = vim.tbl_extend("keep", telescope_opts or {}, require("telescope.themes").get_dropdown {})
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
end

-- F.ts_fallback_lsp_highlighting(bufnr)
--    local ts_utils = require('nvim-treesitter.ts_utils')
--    local locals = require('nvim-treesitter.locals')

--    local node_at_point = ts_utils.get_node_at_cursor()
--    if not node_at_point then
--       return
--    end

--    local HL_NAMESPACE = vim.api.nvim_create_namespace('ts_lsp.highlight')
--    local refs = {}
--    local ref = {}

--    local def_node, scope = locals.find_definition(node_at_point, bufnr)
--    if def_node ~= node_at_point then
--       local range = { def_node:range() }
--       table.insert(refs, {
--          { range[1], range[2] },
--          { range[3], range[4] },
--          vim.lsp.protocol.DocumentHighlightKind.Write,
--       })
--    end

--    local usages = locals.find_usages(def_node, scope, bufnr)
--    for _, node in ipairs(usages) do
--       local range = { node:range() }
--       table.insert(refs, {
--          { range[1], range[2] },
--          { range[3], range[4] },
--          vim.lsp.protocol.DocumentHighlightKind.Read,
--       })
--    end

--    local function kind_to_hl_group(kind)
--       return kind == vim.lsp.protocol.DocumentHighlightKind.Text
--          or kind == vim.lsp.protocol.DocumentHighlightKind.Read
--          or kind == vim.lsp.protocol.DocumentHighlightKind.Write
--    end

--    local function get_references(bufnr)
--        return ref[bufnr] or {}
--    end

--    local function pos_before(pos1, pos2)
--        if pos1[1] < pos2[1] then return true end
--        if pos1[1] > pos2[1] then return false end
--        if pos1[2] < pos2[2] then return true end
--        return false
--    end

--    local function pos_equal(pos1, pos2)
--        return pos1[1] == pos2[1] and pos1[2] == pos2[2]
--    end

--    local function ref_before(ref1, ref2)
--        return pos_before(ref1[1], ref2[1]) or pos_equal(ref1[1], ref2[1]) and pos_before(ref1[2], ref2[2])
--    end

--    local function buf_sort_references(bufnr)
--        local should_sort = false
--        for i, ref in ipairs(get_references(bufnr)) do
--            if i > 1 then
--                if not ref_before(get_references(bufnr)[i - 1], ref) then
--                    should_sort = true
--                    break
--                end
--            end
--        end

--        if should_sort then
--            table.sort(get_references(bufnr), ref_before)
--        end
--    end

--    local function is_pos_in_ref(pos, ref)
--        return (pos_before(ref[1], pos) or pos_equal(ref[1], pos)) and (pos_before(pos, ref[2]) or pos_equal(pos, ref[2]))
--    end

--    local function bisect_left(references, pos)
--        local l, r = 1, #references + 1
--        while l < r do
--            local m = l + math.floor((r - l) / 2)
--            if pos_before(references[m][2], pos) then
--                l = m + 1
--            else
--                r = m
--            end
--        end
--        return l
--    end

--    local function buf_get_references(bufnr)
--        return get_references(bufnr)
--    end

--    local function buf_set_references(bufnr, references)
--        ref[bufnr] = references
--        buf_sort_references(bufnr)
--    end

--    local function buf_cursor_in_references(bufnr, cursor_pos)
--        if not get_references(bufnr) then
--            return false
--        end

--        local i = M.bisect_left(get_references(bufnr), cursor_pos)

--        if i > #get_references(bufnr) then
--            return false
--        end
--        if not M.is_pos_in_ref(cursor_pos, get_references(bufnr)[i]) then
--            return false
--        end

--        return true
--    end

--    local function buf_highlight_references(bufnr, references)
--       if #references < 2 then
--          return
--       end

--       local cursor_pos = function()
--          local winid = vim.api.nvim_get_current_win()
--          local cursor = vim.api.nvim_win_get_cursor(winid)
--          cursor[1] = cursor[1] - 1 -- we always want line to be 0-indexed
--          return cursor
--       end
--       for _, reference in ipairs(references) do
--          if not ref.is_pos_in_ref(cursor_pos, reference) then
--             F.range(
--                bufnr,
--                reference[1],
--                reference[2],
--                reference[3]
--             )
--          end
--       end
--    end

--    local function range(bufnr, start, finish, kind)
--       local region = vim.region(bufnr, start, finish, 'v', false)
--       for linenr, cols in pairs(region) do
--          local end_row
--          if cols[2] == -1 then
--             end_row = linenr + 1
--             cols[2] = 0
--          end
--          vim.api.nvim_buf_set_extmark(bufnr, HL_NAMESPACE, linenr, cols[1], {
--             hl_group = kind_to_hl_group(kind),
--             end_row = end_row,
--             end_col = cols[2],
--             priority = 1000,
--             strict = false,
--          })
--       end
--    end

--    local function buf_clear_references(bufnr)
--       vim.api.nvim_buf_clear_namespace(bufnr, HL_NAMESPACE, 0, -1)
--    end

--    vim.print(refs)
-- end

-- Python Venv
local set_venv = function(venv)
   local ORIGINAL_PATH = vim.fn.getenv "PATH"
   local venv_bin_path = venv.path .. "/bin"
   vim.fn.setenv("PATH", venv_bin_path .. ":" .. ORIGINAL_PATH)
   vim.fn.setenv("VIRTUAL_ENV", venv.path)
end

F.get_current_venv = function()
   return vim.g.python_venv
end

local get_venvs = function(venvs_path)
   local success, Path = pcall(require, "plenary.path")
   if not success then
      vim.notify("Could not require plenary: " .. Path, vim.log.levels.WARN)
      return
   end
   -- local scan_dir = require("plenary.scandir").scan_dir

   local paths = venvs_path -- scan_dir(venvs_path, { depth = 1, only_dirs = true })
   local venvs = {}
   for _, path in ipairs(paths) do
      table.insert(venvs, {
         name = Path:new(path):make_relative(vim.fn.expand "~/"),
         path = path,
      })
   end
   return venvs
end

F.pick_venv = function()
   local venvs_paths = {
      vim.fn.expand "~/dev/audioToText-bot",
      vim.fn.stdpath "data" .. "nvim_python_venv",
   }

   vim.ui.select(get_venvs(venvs_paths), {
      prompt = "Select python venv",
      format_item = function(item)
         return ("%s (%s)"):format(item.name, item.path)
      end,
   }, function(choice)
      if not choice then
         return
      end
      set_venv(choice)
   end)
end

F.set_highlights = function(hls)
   for group, settings in pairs(hls) do
      vim.api.nvim_set_hl(0, group, settings)
   end
end

F.get_current_buf_lsp_capabilities = function()
   local curBuf = vim.api.nvim_get_current_buf()
   local clients = vim.lsp.get_active_clients { bufnr = curBuf }

   for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
         local capAsList = {}
         for key, value in pairs(client.server_capabilities) do
            if value and key:find "Provider" then
               local capability = key:gsub("Provider$", "")
               table.insert(capAsList, "- " .. capability)
            end
         end
         table.sort(capAsList) -- sorts alphabetically
         local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
         vim.notify(msg, "trace", {
            on_open = function(win)
               local buf = vim.api.nvim_win_get_buf(win)
               vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            end,
            timeout = 14000,
         })
         vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
      end
   end
end

return F
