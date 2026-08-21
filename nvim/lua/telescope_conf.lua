-- lua/telescope_conf.lua
local ok, telescope = pcall(require, "telescope")
if not ok then return end

local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<esc>"] = actions.close },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-space>"] = actions.to_fuzzy_refine,
        },
      },
    },
  },
})

pcall(telescope.load_extension, "live_grep_args")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: find files" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: help" })
vim.keymap.set("n", "<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Telescope: live grep (args)" })
