-- lua/theme_conf.lua

require("nightfox").setup({
  options = {
    transparent = true,   -- set true if you want transparent bg
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    },
  },
})

-- Choose ONE of these:
-- vim.cmd("colorscheme nightfox")      -- default
-- vim.cmd("colorscheme nordfox")
-- vim.cmd("colorscheme duskfox")
-- vim.cmd("colorscheme terafox")
vim.cmd("colorscheme carbonfox")

-- Dracula theme
-- local ok, dracula = pcall(require, "dracula")
-- if not ok then
--   vim.notify("Dracula theme not found!", vim.log.levels.ERROR)
--   return
-- end
-- 
-- dracula.setup({
--   -- show the transparent background?
--   transparent_bg = false,
--   -- italic comment
--   italic_comment = true,
-- })
-- 
-- -- Apply the theme
-- vim.cmd("colorscheme dracula")
