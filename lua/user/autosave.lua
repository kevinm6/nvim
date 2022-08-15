-----------------------------------
--  File         : autosave.lua
--  Description  : run on autosave
--  Author       : Kevin
--  Last Modified: 14 Aug 2022, 10:14
-----------------------------------

local bufnr = 36

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
  pattern = "ListTesting.java",
  callback = function()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "output of java main class file:" })
    vim.fn.jobstart({"javac", "ListTesting.java"}, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,
      on_stderr = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end
    })
    vim.fn.jobstart({"java", "ListTesting"}, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end,
      on_stderr = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
        end
      end
    })
  end

})
