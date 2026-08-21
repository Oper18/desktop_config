-- lua/keymaps_conf.lua
local map = vim.keymap.set

-- Quick save / quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics float" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Folding
map("n", "za", "za", { desc = "Toggle fold" })
map("n", "zo", "zo", { desc = "Open fold" })
map("n", "zc", "zc", { desc = "Close fold" })
map("n", "zR", "zR", { desc = "Open all folds" })
map("n", "zM", "zM", { desc = "Close all folds" })

-- Folding keymaps
vim.keymap.set("n", "z0", "zM", { desc = "Fold: close all" })
vim.keymap.set("n", "z9", "zR", { desc = "Fold: open all" })
vim.keymap.set("n", "<leader>z", "za", { desc = "Fold: toggle under cursor" })

vim.keymap.set("n", "]r", function()
  require("illuminate").goto_next_reference(false)
end, { desc = "Next reference" })

vim.keymap.set("n", "[r", function()
  require("illuminate").goto_prev_reference(false)
end, { desc = "Prev reference" })

-- local api = require("Comment.api")

-- -- Comment current line
-- vim.keymap.set("n", "\\c", function()
--   api.comment.linewise.current()
-- end, { desc = "Comment line" })
-- 
-- -- Uncomment current line
-- vim.keymap.set("n", "\\c ", function()
--   api.uncomment.linewise.current()
-- end, { desc = "Uncomment line" })
-- 
-- -- Comment selection
-- vim.keymap.set("v", "\\c", function()
--   api.comment.linewise(vim.fn.visualmode())
-- end, { desc = "Comment selection" })
-- 
-- -- Uncomment selection
-- vim.keymap.set("v", "\\c ", function()
--   api.uncomment.linewise(vim.fn.visualmode())
-- end, { desc = "Uncomment selection" })

-- -- Comment current line
-- vim.keymap.set("n", "<leader>c", function()
--   api.comment.linewise.current()
-- end, { desc = "Comment line" })
-- 
-- -- Uncomment current line
-- vim.keymap.set("n", "<leader>c<space>", function()
--   api.uncomment.linewise.current()
-- end, { desc = "Uncomment line" })
-- 
-- -- Comment selection
-- vim.keymap.set("v", "<leader>c", function()
--   api.comment.linewise(vim.fn.visualmode())
-- end, { desc = "Comment selection" })
-- 
-- -- Uncomment selection
-- vim.keymap.set("v", "<leader>c<space>", function()
--   api.uncomment.linewise(vim.fn.visualmode())
-- end, { desc = "Uncomment selection" })
