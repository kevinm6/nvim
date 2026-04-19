-------------------------------------
-- title: notes.lua
-- abstract: module to manage notes
-- author: Kevin
-- date: 19 Apr 2026, 20:42
-------------------------------------

local note = {}

---Get available notes
---@return table
local function get_notes()
  local notes = {}

  local notes_data_path = vim.fn.expand "~/Documents/Notes"
  local notes_files = vim.split(vim.fn.globpath(notes_data_path, "/**/*.md"), "\n", { trimempty = true })

  for _, f in pairs(notes_files) do
    table.insert(notes, f)
  end
  return notes
end

---Delete selected notes
function note.delete_note()
  local notes = get_notes()

  if #notes >= 1 then
    pcall(require, "snacks")
    vim.ui.select(notes, {
      prompt = "Select note to delete:",
      default = nil,
    }, function(choice)
      if choice then
        vim.fn.jobstart("mv " .. vim.fn.fnameescape(choice) .. " ~/.Trash", {
          detach = true,
          on_exit = function()
            local choice_name = vim.fn.fnamemodify(choice, ":t")
            vim.notify("Notes: note < " .. choice_name .. " > deleted!", vim.log.levels.WARN)
          end,
        })
      end
    end)
  else
    vim.notify("Notes: no notes to delete", vim.log.levels.WARN, { title = " Notes" })
  end
end

---Restore selected notes
function note.open_note()
  local notes = get_notes()

  if #notes >= 1 then
    pcall(require, "snacks.picker")
    vim.ui.select(notes, {
      prompt = " > Select note to open",
      default = nil,
      format_item = function(item)
        local note_name = vim.fn.fnamemodify(item, ":t:r")
        return note_name
      end,
    }, function(choice)
      if choice then
        vim.cmd.edit(choice)
      end
    end)
  else
    vim.notify("Notes: no saved notes found.", vim.log.levels.WARN)
  end
end

return note