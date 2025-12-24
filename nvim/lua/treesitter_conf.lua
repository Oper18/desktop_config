require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "go", "typescript", "tsx", "javascript" }, -- install the ones you want
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}
