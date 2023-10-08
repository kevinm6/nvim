-------------------------------------
--  File         : compilers.lua
--  Description  : get compilers
--  Author       : Kevin
--  Last Modified: 14 Oct 2023, 09:11
-------------------------------------

local C = {}

---Compilers to use for matching filetype
---@type table
C.compiler = {
   java = "cd '$dir' && javac '$fileName' && java $fileNameWithoutExt",
   c = "gcc -Wall '$file' -o $fileName && ./$fileName",
   cpp = "g++ '$file' -o $fileName && ./$fileName",
   rust = "cd $dir && rustc $fileName && ./$fileNameWithoutExt",
   php = "php -lq $file",
   sh = "sh '$file'",
   bash = "bash '$file'",
   zsh = "zsh '$file'",
   markdown = "glow '$file'",
   scala = "cd '$dir' && scalac '$fileName' && scala $fileName",
   lua = {
      prg = "nvim -l $file",
      efmt = "%f",
   },
   go = {
      prg = "go run $file",
      efmt = "%-G# %.%#, %A%f:%l:%c: %m, %A%f:%l: %m, %C%*\\s%m, %-G%.%#",
   },
   python = {
      prg = "python3 -u $file",
      efmt = '%C %.%#,%A  File "%f"\\, line %l%.%#,%Z%[%^ ]%\\@=%m',
   },
   erlang = {
      prg = "erlc -Wall %:S",
      efmt = "%f:%l:%c: %m",
   },
   javascript = "node $file",
   ocaml = "ocaml $file",
}

---Get matching compiler from current filetype
---@return any compilers all compilers available w/ Vim
local get_matching_compiler = function(filetype)
   local compilers = vim.fn.globpath("$VIMRUNTIME/compiler", filetype .. ".vim", 0, 0)

   return #compilers > 0 and vim.fn.fnamemodify(compilers, ":t:r") or nil
end


---Get command and replace placeholders < $varName >
---@param command any command to be parsed
local function getCommand(command)
   local filepath = vim.fn.expand("%:p")
   local clean_cmd = command

   command = command:gsub("$fileNameWithoutExt", vim.fn.fnamemodify(filepath, ":t:r"))
   command = command:gsub("$fileName", vim.fn.fnamemodify(filepath, ":t"))
   command = command:gsub("$file", filepath)
   command = command:gsub("$dir", vim.fn.fnamemodify(filepath, ":p:h"))
   command = command:gsub("$end", "")

   return (command == clean_cmd) and command or ("%s %s"):format(command, filepath)
end


---Select compiler from vimruntime compilers
---or enter a custom command to compile the current file.
---If a custom command is entered, the same filetypes open
---in the same nvim session will use the same command.
local function select_compiler()
   local compilers = vim.fn.globpath(vim.fn.expand "$VIMRUNTIME/compiler", "*.vim", 1, 1)
   table.insert(compilers, 1, "CUSTOM")
   vim.ui.select(compilers, {
      prompt = "  Select compiler",
      format_item = function(f)
         return vim.fn.fnamemodify(f, ":t:r")
      end,
   }, function(choice)
         if choice then
            if choice == "CUSTOM" then
               local prompt_msg = [[ Enter command to compile
(vars: $file,$fileName,$fileNameWithoutExt,$dir)]]
               vim.ui.input({ prompt = prompt_msg}, function(input)
                  if input then
                     vim.opt_local.makeprg = input
                     C.compiler[vim.bo.filetype] = input
                  end
               end)
               return
            end
            local chosen_compiler = vim.fn.fnamemodify(choice, ":t:r")
            vim.cmd.compiler(chosen_compiler)
            C.compiler[vim.bo.filetype] = chosen_compiler
         end
      end)
end


---Open terminal in a float window.
---@param command string command runned by the spawned shell
local function float_terminal(command)
   local cols, lines = vim.o.columns, vim.o.lines
   local opts = {
      relative = 'editor',
      row = math.floor(lines * 6/20),
      col = math.floor(cols * 4/20),
      width = math.floor(cols * 0.6),
      height = math.floor(lines * 0.4),
      style = 'minimal',
      border = 'rounded',
      title = 'Run File in Terminal',
      title_pos = 'center'
   }

   local bufnr = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_open_win(bufnr, true, opts)
   vim.fn.termopen(command)

   vim.wo.winblend = 16
   vim.bo.bufhidden = 'hide'
   vim.wo.signcolumn = 'no'
   vim.bo.buflisted = false
end


---Open Terminal and run command passed as param.
---The default terminal spawned is toggleterm if is available, instead default
---nvim-terminal is launched.
---@param command string command to be runned on the spawned shell in terminal
---@param direction string type of window where launch terminal
local function run_in_terminal(command, direction)
   local full_command = getCommand(command)

   local has_toggleterm, toggleterm = pcall(require, "toggleterm.terminal")
   if has_toggleterm then
      toggleterm.Terminal:new {
         cmd = full_command,
         direction = direction,
         close_on_exit = false
      }:toggle()
   else
      if direction == 'horizontal' then
         vim.cmd(("split | resize 14 | terminal '%s'"):format(full_command))
      elseif direction == 'vertical' then
         vim.cmd(("vsplit | vertical resize 80 | terminal '%s'"):format(full_command))
      elseif direction == 'float' then
         float_terminal(full_command)
      elseif direction == 'tab' then
         vim.cmd.tabnew()
         vim.fn.termopen(full_command)
      end
   end
end


---Set keymap for compile and run file.
---I do some check in the keymap to avoid asking user to choose a compiler if
---not present every time a file with specific filetype is open.
---In this way, only if user wants to compile/run the file we prompt the selection
---@param buf any bufId for which set keymap
local set_keymaps = function(buf)
   vim.keymap.set(
      { "n", "v" },
      "<leader>R",
      function() end,
      { buffer = buf, desc = "Run" }
   )

   vim.keymap.set("n", "<leader>Rr", function()
      if not C.compiler[vim.bo.filetype] then
         select_compiler()
      else
         local command = C.compiler[vim.bo.filetype]
         run_in_terminal(command, 'horizontal')
      end
   end, { buffer = buf, desc = "Run File" })

   vim.keymap.set("n", "<leader>Rf", function()
      if not C.compiler[vim.bo.filetype] then
         select_compiler()
      else
         local command = C.compiler[vim.bo.filetype]
         run_in_terminal(command, 'float')
      end
   end, { buffer = buf, desc = "Run in float" })

   vim.keymap.set("n", "<leader>Rv", function()
      if not C.compiler[vim.bo.filetype] then
         select_compiler()
      else
         local command = C.compiler[vim.bo.filetype]
         run_in_terminal(command, 'vertical')
      end
   end, { buffer = buf, desc = "Run vertical" })

   vim.keymap.set("n", "<leader>Rt", function()
      if not C.compiler[vim.bo.filetype] then
         select_compiler()
      else
         local command = C.compiler[vim.bo.filetype]
         run_in_terminal(command, 'tab')
      end
   end, { buffer = buf, desc = "Run in tab" })

   vim.keymap.set("n", "<leader>Rc", function()
      vim.cmd.make()
      vim.cmd.copen()
   end, { buffer = buf, desc = "Compile File" })
end


---Set compiler based on filetype.
---If custom_compiler is not specified the default one is used ($VIMRUNTIME/compiler/)
---@param ev table event matched for filetype
C.set_compiler = function(ev)
   local filetype = ev.match
   local buf = ev.buf

   local custom_compiler = C.compiler[filetype]
   if custom_compiler == 0 then return end

   if custom_compiler then
      if type(custom_compiler) == "table" then
         custom_compiler.prg = getCommand(custom_compiler.prg)

         vim.opt_local.makeprg = custom_compiler.prg
         vim.opt_local.errorformat = custom_compiler.efmt
      else
         vim.opt_local.makeprg = getCommand(custom_compiler)
      end

      C.compiler[filetype] = custom_compiler
   elseif get_matching_compiler(filetype) then
      local default_compiler = get_matching_compiler(filetype)

      vim.schedule_wrap(function()
         local prompt = ("Use < %s > as compiler for current filetype (%s)?"):format(
            default_compiler,
            filetype
         )
         local choice = vim.fn.confirm(prompt, "&Yes\n&No\n&Enter input")
         if choice == 1 then
            vim.cmd.compiler(default_compiler)
            C.compiler[filetype] = default_compiler

         elseif choice == 2 then
            C.compiler[filetype] = 0

         elseif choice == 3 then
            vim.ui.input({ prompt = "  Enter command used for compile: "}, function(input)
               if input then
                  vim.cmd.compiler(input)
                  C.compiler[filetype] = input
               end
            end)
         end

      end)()
   end

   set_keymaps(buf)
end


return C
