-------------------------------------
--  File         : pdf.lua
--  Description  : use Neovim as pdf reader (need pdftotext binaries)
--  Author       : Kevin
--  Last Modified: 14 Oct 2023, 09:16
-------------------------------------

local M = {}

local pdf_cache = {}

---Read file and load buffer
---@private
---@param cache_file string file already created to load and show in buffer
local read_file = function(cache_file)
   local command = string.format("bdelete | edit %s | set readonly | set filetype=text", cache_file)
   vim.cmd(command)
end

---Load pdf file using <pdftotext> shell command
---@param file string pdf file to be displayed
M.load_pdf = function(file)
   if vim.g[file] == 1 then return end

   local pdf = vim.fn.escape(vim.fn.expand(file), "'")
   local pdf_cache_file = ""

   if pdf_cache[pdf] ~= nil then
      pdf_cache_file = pdf_cache[pdf]
      read_file(pdf_cache_file)
   else
      local temp_file = string.format("%s_%s.txt", vim.fn.tempname(), vim.fn.fnamemodify(file, ":t:r"))
      pdf_cache_file = vim.fn.escape(temp_file, "'")
      local shell_command = string.format("pdftotext -nopgbrk -layout '%s' '%s'",
         pdf,
         pdf_cache_file
      )
      vim.fn.system(shell_command, {})

      read_file(pdf_cache_file)
      pdf_cache[pdf] = pdf_cache_file
   end

   vim.g[file] = 1
end

return M
