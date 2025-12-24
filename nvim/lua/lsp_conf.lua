local lsp = require("lsp-zero")

lsp.setup_servers({
  'ts_ls',
  'rust_analyzer',
  'bashls',
  -- 'jedi_language_server',
  'eslint',
  -- 'lua_ls',
  'gopls',
  -- 'angularls',
  -- 'pyright',
  -- 'ruff_lsp',
  -- 'ruff',
  'dartls',
})

lsp.skip_server_setup({ 'eslint' })

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

require('lspconfig').pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 90
        },
      }
    }
  }
})

require'lspconfig'.ruff.setup{
  init_options = {
    settings = {
      args = {
        ignore = {'W391'},
        maxLineLength = 90
      }
    },
    confiiguration = "~/.config/ruff/ruff.toml"
  }
}

require("lspconfig").eslint.setup({
  root_dir = function()
    return "/home/oper/.config/eslint"
  end,
  settings = {
    workingDirectory = {
      mode = "location",
      directory = "/home/oper/.config/eslint"
    }
  },
  on_attach = function(client, bufnr)
    -- Disable if we encounter config errors
    client.stop()
  end,
  handlers = {
    ["window/showMessage"] = function() end, -- Suppress error messages
  },
})

require'lspconfig'.dartls.setup{
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = true,
    outline = true,
    suggestFromUnimportedLibraries = true
  }
}

vim.diagnostic.config({
    virtual_text = true
})

-- Autocmd to disable LSP and diagnostics for 'startify' filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"startify", "packer"},
  callback = function()
    -- Disable diagnostics
    vim.diagnostic.enable(true, { buffer = 1 })

    -- Optionally stop LSP clients if they are active
    local clients = vim.lsp.get_clients()
    for _, client in ipairs(clients) do
      vim.lsp.stop_client(client.id)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    -- Only use ruff for formatting
    vim.lsp.buf.format({
      async = false,
      filter = function(client) return client.name == "ruff" end,
    })
  end,
})
