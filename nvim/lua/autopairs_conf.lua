-- lua/autopairs_conf.lua
-- local ok, npairs = pcall(require, "nvim-autopairs")
-- if not ok then
--   return
-- end
-- 
-- npairs.setup({
--   check_ts = true, -- use treesitter to be smarter
--   fast_wrap = {},
-- })
-- 
-- -- If you use nvim-cmp, this makes autopairs add () after confirming functions, etc.
-- local cmp_ok, cmp = pcall(require, "cmp")
-- if cmp_ok then
--   local cmp_autopairs = require("nvim-autopairs.completion.cmp")
--   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- end

local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
  return
end

npairs.setup({
  check_ts = true,        -- treesitter-aware
  enable_check_bracket_line = false,
  fast_wrap = {},
})

-- IMPORTANT: enable basic insert-mode mappings
npairs.enable()

-- nvim-cmp integration (you already had this part right)
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
