-------------------------------------
--  File         : notes.lua
--  Description  : module to manage notes
--  Author       : Kevin
--  Last Modified: 24 Mar 2024, 13:32
-------------------------------------

local note = {}

---Get available notes
---@private
---@return table
local function get_notes()
   local notes = {}

   local notes_data_path = vim.fn.expand "~/Documents/notes"
   local notes_files = vim.split(
      vim.fn.globpath(notes_data_path, "*.md"),
      "\n",
      { trimempty = true }
   )
   local obsidian_path = vim.fn.expand "~/Library/Mobile Documents/iCloud~md~obsidian/Documents"
   local obsidian_notes = vim.split(
      vim.fn.globpath(obsidian_path, "**/*.md"),
      "\n",
      { trimempty = true }
   )
   for _, n in ipairs(obsidian_notes) do
      table.insert(notes_files, n)
   end

   for _, f in pairs(notes_files) do
      table.insert(notes, f)
   end
   return notes
end

---Delete selected notes
function note.delete_note()
   local notes = get_notes()

   if #notes >= 1 then
      require "telescope"
      vim.ui.select(notes, {
         prompt = "Select note to delete:",
         default = nil,
      }, function(choice)
         if choice then
            vim.fn.jobstart("mv " .. vim.fn.fnameescape(choice) .. " ~/.Trash", {
               detach = true,
               on_exit = function()
                  local choice_name = vim.fn.fnamemodify(choice, ":t")
                  vim.notify(
                     string.format("Note < %s > deleted!", choice_name),
                     vim.log.levels.WARN
                  )
               end,
            })
         end
      end)
   else
      vim.notify("No notes to delete", vim.log.levels.WARN)
   end
end

---Restore selected notes
function note.open_note()
   local notes = get_notes()

   if #notes >= 1 then
      vim.ui.select(notes, {
         prompt = " > Select note to open",
         default = nil,
         format_item = function(item)
            local note_name = vim.fn.fnamemodify(item, ':t:r')
            return note_name
         end
      }, function(choice)
         local note_name = vim.fn.fnamemodify(choice, ":p:t:r")
         if choice then
            vim.cmd.edit(note_name)
         end
      end)
   else
      vim.notify("No saved notes found.", vim.log.levels.WARN)
   end
end

return note