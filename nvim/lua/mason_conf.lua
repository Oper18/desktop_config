-- lua/mason_conf.lua
local ok, mason = pcall(require, "mason")
if ok then mason.setup() end

local ok2, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok2 then
  mason_lspconfig.setup({
    -- IMPORTANT: Use *lspconfig server names* here (not Mason package names).
    ensure_installed = {
      "ty",           -- Astral ty (Python type checker + LSP)
      "ruff",         -- Ruff language server (lint/format)
      "lua_ls",
      "gopls",
      "rust_analyzer",
      "bashls",
      "ts_ls",
    },
    automatic_installation = true,
  })
end
