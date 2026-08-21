-- lua/kulala_conf.lua
local ok, kulala = pcall(require, "kulala")
if not ok then return end

kulala.setup({
  global_keymaps = false,
})

vim.keymap.set({ "n", "v" }, "<leader>ms", function() kulala.run() end,     { desc = "Kulala: send request" })
vim.keymap.set({ "n", "v" }, "<leader>ma", function() kulala.run_all() end, { desc = "Kulala: send all" })
vim.keymap.set("n", "<leader>mb", function() kulala.scratchpad() end,       { desc = "Kulala: scratchpad" })
vim.keymap.set("n", "<leader>mr", function() kulala.replay() end,           { desc = "Kulala: replay last" })
vim.keymap.set("n", "<leader>mi", function() kulala.inspect() end,          { desc = "Kulala: inspect request" })
vim.keymap.set("n", "<leader>mt", function() kulala.toggle_view() end,      { desc = "Kulala: toggle view" })
