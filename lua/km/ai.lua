-------------------------------------
-- title: ai.lua
-- abstract: AI interops with Neovim
-- author: Kevin
-- date: 21 Apr 2026, 09:06
-------------------------------------

require("sidekick").setup {
  opts = {
    cli = {
      mux = {
        -- backend = "zellij",
        enabled = false,
      },
    },
  },
}

vim.keymap.set("i", "<tab>", function()
    -- if there is a next edit, jump to it, otherwise apply it if any
    if not require("sidekick").nes_jump_or_apply() then
      return "<Tab>" -- fallback to normal tab
    end
  end,
  { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").focus() end,
  { desc = "Sidekick Focus" })
vim.keymap.set("n", "<leader>aa",
  function() require("sidekick.cli").toggle() end,
  { desc = "Sidekick Toggle CLI", })
vim.keymap.set("n",
  "<leader>as",
  function() require("sidekick.cli").select() end,
  -- Or to select only installed tools:
  -- require("sidekick.cli").select({ filter = { installed = true } })
  { desc = "Select CLI",
  })
vim.keymap.set("n", "<leader>ad",
  function() require("sidekick.cli").close() end,
  { desc = "Detach a CLI Session", })
vim.keymap.set({ "x", "n" },
  "<leader>at",
  function() require("sidekick.cli").send({ msg = "{this}" }) end,
  { desc = "Send This", })
vim.keymap.set("n",
  "<leader>af",
  function() require("sidekick.cli").send({ msg = "{file}" }) end,
  { desc = "Send File",
  })
vim.keymap.set("x",
  "<leader>av",
  function() require("sidekick.cli").send({ msg = "{selection}" }) end,
  { desc = "Send Visual Selection", })
vim.keymap.set({ "n", "x" },
  "<leader>ap",
  function() require("sidekick.cli").prompt() end,
  {
    desc = "Sidekick Select Prompt",
  })
-- Example of a keybinding to open Claude directly
vim.keymap.set("n",
  "<leader>ac",
  function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
  {
    desc = "Sidekick Toggle Claude",
  })