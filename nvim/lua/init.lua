-- lua/init.lua
-- Main Lua entrypoint (required by init.vim)

require("settings_conf")
require("keymaps_conf")

-- Packer (plugins) must be loaded before plugin configs
require("packer_conf")

require("theme_conf")

-- Plugin configs
require("telescope_conf")
require("nerdtree_conf")
require("treesitter_conf")
require("folds_conf")
require("harpoon_conf")
require("kulala_conf")
require("mason_conf")
require("lsp_conf")
require("autopairs_conf")
