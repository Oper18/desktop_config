-- lua/packer_conf.lua
-- Plugin manager: packer.nvim

local fn = vim.fn

-- Bootstrap packer if missing
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd("packadd packer.nvim")
end

local ok, packer = pcall(require, "packer")
if not ok then
  return
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- Themes
  use("EdenEast/nightfox.nvim")
  use("maxmx03/dracula.nvim")

  -- UI icons (needed by telescope, etc.)
  use("nvim-tree/nvim-web-devicons")

  -- Telescope
  use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope-live-grep-args.nvim")

  -- NERDTree
  use("preservim/nerdtree")

  -- Treesitter (THIS fixes: nvim-treesitter.configs not found)
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

  -- Folding (best experience) - uses Treesitter/indent providers
  use("kevinhwang91/nvim-ufo")
  use("kevinhwang91/promise-async")

  -- Harpoon (your config looks like Harpoon v2 style already)
  use({ "ThePrimeagen/harpoon", branch = "harpoon2" })

  -- Kulala (keep if you use it)
  use("mistweaverco/kulala.nvim")

  -- LSP + completion
  use("neovim/nvim-lspconfig")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("saadparwaiz1/cmp_luasnip")
  use("L3MON4D3/LuaSnip")

  use({
    "windwp/nvim-autopairs",
    config = function()
      require("autopairs_conf")
    end,
  })
  use({
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate_conf")
    end,
  })
  -- use({
  --   "numToStr/Comment.nvim",
  --   config = function()
  --     require("Comment").setup()
  --   end,
  -- })
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        toggler = {
          line = "<leader>c",      -- toggle comment on current line
        },
        opleader = {
          line = "<leader>c",      -- comment in visual mode
        },
        extra = {
          -- extra mappings can be defined here if needed
        },
      }
  
      -- Optional: highlight the commented line / region
      vim.cmd "highlight Comment gui=italic"
    end
  }

  use("terryma/vim-multiple-cursors")

  use 'preservim/tagbar'

end)
