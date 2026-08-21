-- lua/nerdtree_conf.lua
-- Basic NERDTree setup + keymaps

vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeMinimalUI = 1
vim.g.NERDTreeDirArrows = 1

vim.keymap.set("n", "<leader>t", "<cmd>NERDTreeToggle<cr>", { desc = "NERDTree: toggle" })
vim.keymap.set("n", "<leader>nf", "<cmd>NERDTreeFind<cr>", { desc = "NERDTree: find current file" })
