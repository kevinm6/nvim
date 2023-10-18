-------------------------------------
--  File         : notes.lua
--  Description  : module to manage notes
--  Author       : Kevin
--  Last Modified: 14 Oct 2023, 09:13
-------------------------------------

local N = {}

---Get available sessions
---@private
---@return table
local get_notes = function()
   local notes = {}

   local notes_data_path = vim.fn.expand "~/Documents/notes"
   local notes_files = vim.split(
      vim.fn.globpath(notes_data_path, "*.md"),
      "\n",
      { trimempty = true }
   )
   local logseq_path = vim.fn.expand "~/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents"
   local logseq_notes = vim.split(
      vim.fn.globpath(logseq_path, "**/*.md"),
      "\n",
      { trimempty = true }
   )
   for _, note in ipairs(logseq_notes) do
      table.insert(notes_files, note)
   end

   for _, f in pairs(notes_files) do
      table.insert(notes, f)
   end
   return notes
end

---Delete selected session
N.delete_note = function()
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

---Restore selected session
N.open_note = function()
   local notes = get_notes()

   if #notes >= 1 then
      require "telescope"
      vim.ui.select(notes, {
         prompt = " > Select note to open",
         default = nil,
         format_item = function(note)
            local note_name = vim.fn.fnamemodify(note, ':t:r')
            return note_name
         end
      }, function(choice)
         local note_name = vim.fn.fnamemodify(choice, ":p:t:r")
         if choice then
            vim.cmd.edit(choice)
         end
      end)
   else
      vim.notify("No saved notes found.", vim.log.levels.WARN)
   end
end

return N
