-------------------------------------
-- title: pdf.lua
-- abstract: use Neovim as pdf reader (need pdftotext binaries)
-- author: Kevin
-- date: 22 Mar 2026, 17:03
-------------------------------------

local M = {
  pdf_cache = {}
}

---Read file and load buffer
---@private
---@param cache_file string file already created to load and show in buffer
local function read_file(cache_file)
  local command = ("bdelete | edit %s | set readonly | set filetype=text"):format(cache_file)
  vim.cmd(command)
end

---Load pdf file using <pdftotext> shell command
---@param file string pdf file to be displayed
function M.load_pdf(file)
  if vim.g[file] == 1 then return end

  local pdf_file = vim.fn.escape(vim.fn.expand(file), "'")
  local pdf_cache_file = ""

  if M.pdf_cache[pdf_file] ~= nil then
    pdf_cache_file = M.pdf_cache[pdf_file]
    read_file(pdf_cache_file)
  else
    local temp_file = ("%s_%s.txt"):format(vim.fn.tempname(), vim.fn.fnamemodify(file, ":t:r"))
    pdf_cache_file = vim.fn.escape(temp_file, "'")
    local shell_command = ("pdftotext -nopgbrk -layout '%s' '%s'"):format(pdf_file, pdf_cache_file)
    vim.fn.system(shell_command, {})

    read_file(pdf_cache_file)
    M.pdf_cache[pdf_file] = pdf_cache_file
  end

  vim.g[file] = 1
end

---Convert from markdown to pdf, using pandoc
---@param cmd? string extra command args
function M.convert_md_to_pdf(cmd)
  if vim.bo.ft ~= 'markdown' then
    local err_msg = "TOpdf - fileType < %s > not supported" .. vim.bo.ft
    vim.notify(err_msg, vim.log.levels.ERROR, { title = "PDF export" })
    return
  end

  assert(vim.fn.executable 'pandoc' == 1, "TOpdf - pandoc binary is required")

  local file_path = vim.api.nvim_buf_get_name(0)
  local pdf_out_path = string.sub(file_path, 1, -3) .. 'pdf'
  local dir_file_path = vim.fs.dirname(file_path)
  local old_cwd = vim.fn.chdir(dir_file_path)
  local extra_args = cmd ~= "" and vim.split(cmd, " ") or {}

  local args = {
    "pandoc",
    "-V", "geometry:margin=1.5cm",
    -- "--template", "eisvogelk.latex",
    "-f", "gfm+alerts",
    file_path,
    "-o", pdf_out_path,
    "--syntax-highlighting", "tango",
  }

  if next(extra_args) then
    vim.list_extend(args, extra_args)
  end

  vim.notify("TOpdf - starting conversion...\n executing => " .. table.concat(args, " "))
  vim.system(args, { text = true }, function(obj)
    if obj.stderr ~= "" then
      vim.schedule(function()
        vim.notify(("TOpdf - stderr =>\n%q"):format(obj.stderr), vim.log.levels.ERROR, { title = "TOpdf - export" })
        vim.fn.chdir(old_cwd)
      end)
      return
    end

    if obj.stdout ~= "" then
      vim.schedule(function()
        vim.notify("TOpdf - stdout => " .. obj.stdout)
      end)
    end

    vim.schedule(function()
      vim.notify("TOpdf - conversion complete")
      vim.fn.chdir(old_cwd)
      vim.ui.open(pdf_out_path)
    end)
  end)
end

return M