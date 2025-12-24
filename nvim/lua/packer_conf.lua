-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use({ 'rose-pine/neovim', as = 'rose-pine' })

--  use('ThePrimeagen/harpoon')
  use({
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon_conf")  -- this runs after harpoon is on runtimepath
    end,
  })
  use 'mbbill/undotree'
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v2.x',
	  requires = {
		  -- LSP Support
	  {'neovim/nvim-lspconfig'},             -- Required
	  {                                      -- Optional
	      'williamboman/mason.nvim',
	      run = function()
	    	  pcall(vim.cmd, 'MasonUpdate')
	      end,
	  },
	  {'williamboman/mason-lspconfig.nvim'}, -- Optional

	  -- Autocompletion
	  {'hrsh7th/nvim-cmp'},     -- Required
	  {'hrsh7th/cmp-nvim-lsp'}, -- Required
	  {'L3MON4D3/LuaSnip'},     -- Required
    }
  }
  use 'aspeddro/gitui.nvim'
  use {
      'nvim-telescope/telescope.nvim',
      requires = {
          { 'nvim-telescope/telescope-live-grep-args.nvim' },
      },
      config = function()
          local telescope = require('telescope')
          local lga_actions = require('telescope-live-grep-args.actions')
          local actions = require('telescope.actions')

          telescope.setup({
              extensions = {
                  live_grep_args = {
                      auto_quoting = true, -- enable/disable auto-quoting
                      mappings = { -- extend mappings
                          i = {
                              ['<C-k>'] = lga_actions.quote_prompt(),
                              ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                              ['<C-space>'] = actions.to_fuzzy_refine,
                          },
                      },
                  }
              }
          })
          
          telescope.load_extension('live_grep_args')
      end
  }
  -- use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }
  use 'olimorris/codecompanion.nvim'

  use 'MunifTanjim/nui.nvim'
  use 'MeanderingProgrammer/render-markdown.nvim'

  use 'hrsh7th/nvim-cmp'
  use 'nvim-tree/nvim-web-devicons'
  use 'HakonHarnes/img-clip.nvim'
  use 'zbirenbaum/copilot.lua'
  use 'stevearc/dressing.nvim'
  use 'folke/snacks.nvim'

  -- Additional plugins for enhanced development experience
  use {
    'folke/trouble.nvim',
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  -- Enhanced search and replace
  use {
    'nvim-pack/nvim-spectre',
    config = function()
      require('spectre').setup()
    end
  }

  -- Better terminal integration
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = function()
      require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        direction = 'horizontal',
      }
    end
  }

--  use({
--    "mistweaverco/kulala.nvim",
--    requires = { "nvim-lua/plenary.nvim" },  -- kulala uses plenary
--    config = function(lobal_keymaps_prefix = "<leader>M",
--        kulala_keymaps_prefix = "",
--      })
--    end,
--  })

  use({
    "mistweaverco/kulala.nvim",
    requires = { "nvim-lua/plenary.nvim" },  -- dependency
    -- no ft, no keys, no config here
  })
end)
