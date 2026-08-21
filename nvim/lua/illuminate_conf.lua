local ok, illuminate = pcall(require, "illuminate")
if not ok then
  return
end

illuminate.configure({
  delay = 150, -- ms before highlighting
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  filetypes_denylist = {
    "NvimTree",
    "TelescopePrompt",
    "alpha",
    "dashboard",
    "help",
  },
  under_cursor = true,
})

-- Make illuminate highlights brighter (illuminate-only)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "IlluminatedWordText", {
      bg = "#3b3f4c",
      underline = true,
    })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
      bg = "#3b3f4c",
      underline = true,
    })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
      bg = "#3b3f4c",
      underline = true,
    })
  end,
})

-- Apply immediately for current colorscheme
vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#3b3f4c", underline = true })
vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#3b3f4c", underline = true })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3b3f4c", underline = true })
