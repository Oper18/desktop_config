-- ~/.config/nvim/lua/lsp_conf.lua

-- nvim-cmp (completion)
local ok_cmp, cmp = pcall(require, "cmp")
local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local ok_luasnip, luasnip = pcall(require, "luasnip")

if ok_cmp and ok_luasnip then
  cmp.setup({
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" },
    }),
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- LspAttach mappings (native way)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
    map("n", "K", vim.lsp.buf.hover, "LSP: hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
    map("n", "gr", vim.lsp.buf.references, "LSP: references")
    map("i", "<C-h>", vim.lsp.buf.signature_help, "LSP: signature help")
  end,
})

-- Configure servers (native)
-- For built-in lspconfig-provided configs, vim.lsp.config() merges changes. :contentReference[oaicite:1]{index=1}
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Ruff (Python lint/format)
vim.lsp.config("ruff", {
  capabilities = capabilities,
  cmd = { "ruff", "server" },
})

-- ty (custom config comes from ~/.config/nvim/lsp/ty.lua)
-- we only override capabilities here
vim.lsp.config("ty", {
  capabilities = capabilities,
})

-- Typescript: use ts_ls (NOT tsserver)
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

-- Enable servers
vim.lsp.enable({
  "lua_ls",
  "ruff",
  "ty",
  "ts_ls",
  -- add your others here if you want:
  -- "gopls",
  -- "rust_analyzer",
  -- "bashls",
})

-- Diagnostics preference
vim.diagnostic.config({ virtual_text = true })

-- Optional: format Python on save using Ruff only
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client) return client.name == "ruff" end,
    })
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        return client.name == "gopls"
      end,
    })
  end,
})
