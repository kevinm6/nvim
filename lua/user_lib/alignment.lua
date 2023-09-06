-------------------------------------
--  File         : alignment.lua
--  Description  : alignment functions
--  Author       : Kevin
--  Last Modified: 26 Jul 2023, 09:56
-------------------------------------

local A = {}

--- align lines from pattern
--- @private
--- @param pattern string RegEx to match text
--- @param startline any start line position
--- @param endline any end line position
local function align_lines(pattern, startline, endline)
   local re = vim.regex(pattern)
   if not pattern or not re then
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
      local s = vim.regex(pattern):match_str(line)
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

--- Alignment text from RegEx
--- @param pattern string RegEx or matching text
A.align = function(pattern)
   local top, bot = vim.fn.getpos "'<", vim.fn.getpos "'>"
   align_lines(pattern, top[2] - 1, bot[2])
   vim.fn.setpos("'<", top)
   vim.fn.setpos("'>", bot)
end

return A
