-- lua/treesitter_conf.lua
local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

ts_configs.setup({
  ensure_installed = {
    "lua",
    "python",
    "go",
    "typescript",
    "javascript",
    "json",
    "yaml",
    "bash",
    "html",
    "css",
  },

  highlight = { enable = true },
  indent = { enable = true },
})
