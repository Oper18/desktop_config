-- local mark = require("harpoon.mark")
-- local ui = require("harpoon.ui")
-- 
-- vim.keymap.set("n", "<leader>a", mark.add_file)
-- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
-- 
-- vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-;>", function() ui.nav_file(4) end)

local harpoon = require("harpoon")

harpoon:setup()

-- Add current file
vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add()
end)

-- Toggle menu
vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- Jump to files 1..4
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
