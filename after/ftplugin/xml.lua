-------------------------------------
-- File         : xml.lua
-- Description  : filetype xml extra config
-- Author       : Kevin
-- Last Modified: 10/05/2025, 11:29
-------------------------------------

vim.api.nvim_create_user_command("UnescapeXml",
    [[:silent! %s/&amp;/&/g | silent! %s/&lt;/</g | silent! %s/&gt;/>/g | silent! %s/&apos;/'/g | silent! %s/&quot;/"/g]],
    { desc = "unescape xml file" })

vim.api.nvim_create_user_command("EscapeXml",
  [[:silent! %s/&/&amp;/g | silent!  %s/</&lt;/g | silent! %s/>/&gt;/g | silent! %s/'/&apos;/g | silent! %s/"/&quot;/g]],
  { desc = "escape xml file" })