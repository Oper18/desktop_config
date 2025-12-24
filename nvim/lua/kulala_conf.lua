-- runs after the plugin is on runtimepath
local ok, kulala = pcall(require, "kulala")
if not ok then return end

kulala.setup({
  -- change if you prefer Kulala's built-in mappings:
  global_keymaps = false,
})

-- explicit, reliable mappings
vim.keymap.set({ "n", "v" }, "<leader>Ms", function() kulala.run() end,     { desc = "Kulala: Send request" })
vim.keymap.set({ "n", "v" }, "<leader>Ma", function() kulala.run_all() end, { desc = "Kulala: Send all" })
vim.keymap.set("n", "<leader>Mb", function() kulala.scratchpad() end,       { desc = "Kulala: Scratchpad" })
vim.keymap.set("n", "<leader>Mr", function() kulala.replay() end,           { desc = "Kulala: Replay last" })
vim.keymap.set("n", "<leader>Mi", function() kulala.inspect() end,          { desc = "Kulala: Inspect request" })
vim.keymap.set("n", "<leader>Mt", function() kulala.toggle_view() end,      { desc = "Kulala: Toggle view" })
