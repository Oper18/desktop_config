-- lua/folds_conf.lua
-- Tree-sitter folds:
-- - when you open a file: start collapsed (once per buffer open)
-- - after that: only YOU open/close folds (no auto-refolding on save/insert leave)

-- Keep folds enabled; don't force them closed later
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 8
vim.opt.foldminlines = 1

-- Choose a foldexpr that works across more Neovim versions:
-- Prefer the nvim-treesitter vimscript foldexpr if available.
local function ts_foldexpr()
  if vim.fn.exists("*nvim_treesitter#foldexpr") == 1 then
    return "nvim_treesitter#foldexpr()"
  end
  -- Newer Neovim has this (0.10+ typically)
  if vim.treesitter and vim.treesitter.foldexpr then
    return "v:lua.vim.treesitter.foldexpr()"
  end
  return nil
end

-- Set folding per-window (foldmethod is window-local)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local fe = ts_foldexpr()
    if not fe then
      -- fallback: at least allow manual folding if TS foldexpr isn't available
      vim.opt_local.foldmethod = "manual"
      return
    end

    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = fe
  end,
})

-- Start collapsed once when the buffer is read (opening a file)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(args)
    -- skip special buffers
    if vim.bo[args.buf].buftype ~= "" then return end
    if not vim.bo[args.buf].modifiable then return end

    -- only once per buffer open (prevents refolding on other events)
    if vim.b[args.buf].did_initial_zM then return end
    vim.b[args.buf].did_initial_zM = true

    -- close all folds
    vim.cmd("silent! normal! zM")
  end,
})
