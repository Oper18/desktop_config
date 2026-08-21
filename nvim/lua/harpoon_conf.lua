-- lua/harpoon_conf.lua (Harpoon v1)
-- local ok_mark, mark = pcall(require, "harpoon.mark")
-- local ok_ui, ui = pcall(require, "harpoon.ui")
-- if not (ok_mark and ok_ui) then
--   return
-- end
-- 
-- vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon: add file" })
-- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon: menu" })
-- 
-- vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end, { desc = "Harpoon: file 1" })
-- vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end, { desc = "Harpoon: file 2" })
-- vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end, { desc = "Harpoon: file 3" })
-- vim.keymap.set("n", "<C-;>", function() ui.nav_file(4) end, { desc = "Harpoon: file 4" })

-- lua/harpoon_conf.lua (Harpoon v2)
local ok, harpoon = pcall(require, "harpoon")
if not ok then
  return
end

harpoon:setup()

-- Add file
vim.keymap.set("n", "<leader>a", function()
  harpoon:list():add() -- some examples use :append(); :add() is common in configs
end, { desc = "Harpoon: add file" })

-- Open menu (pick ONE: leader or ctrl)
vim.keymap.set("n", "<leader>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: menu" })

-- Jump to files
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })
