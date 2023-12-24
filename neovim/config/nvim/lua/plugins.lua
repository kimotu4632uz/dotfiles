local packer_bootstrap = require('utils').packer_bootstrap()


-- Run :PackerCompile when this file edited
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = 'plugins.lua',
  callback = function()
    require('packer').compile()
  end,
})


return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    config = [[require('config.lualine')]],
  }

  use {
    'lambdalisue/fern.vim',
    requires = {
      { 'lambdalisue/fern-renderer-nerdfont.vim', after = 'fern.vim' },
      'lambdalisue/nerdfont.vim',
    },
    config = function()
      vim.g['fern#renderer'] = 'nerdfont'
      vim.g['fern#default_hidden'] = 1
    end,
  }

  use {
    'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup {}
      vim.keymap.set('n', '<S-l>', function() vim.cmd[[BufferLineCycleNext]] end)
      vim.keymap.set('n', '<S-h>', function() vim.cmd[[BufferLineCyclePrev]] end)
      vim.keymap.set('n', '<leader>wh', function() vim.cmd[[BufferLineMoveNext]] end)
      vim.keymap.set('n', '<leader>wl', function() vim.cmd[[BufferLineMovePrev]] end)
      vim.keymap.set('n', '<leader>wp', function() vim.cmd[[BufferLinePick]] end)
      vim.keymap.set('n', '<leader>wc', function() vim.cmd[[BufferLinePickClose]] end)
      vim.keymap.set('n', '<leader>wa', function() vim.cmd[[BufferLineCloseOthers]] end)
    end,
  }

  use 'RRethy/nvim-base16'
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      vim.cmd.colorscheme('nordfox')
    end,
  }

  use 'neovim/nvim-lspconfig'

  use {
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup {
          ui = {
            border = 'rounded',
          }
        }
      end,
    },
    {
      'williamboman/mason-lspconfig.nvim',
      wants = { 'nvim-lspconfig', 'mason.nvim' },
      config = [[require('config.lsp')]],
    },
  }


  use {
    'hrsh7th/nvim-cmp',
    requires = {
      { 'hrsh7th/cmp-buffer',   after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline',  after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path',     after = 'nvim-cmp' },
      'hrsh7th/cmp-nvim-lsp',
      { 'dcampos/cmp-snippy',   after = 'nvim-cmp' },
    },
    config = [[require('config.cmp')]],
    event = 'InsertEnter',
  }

  use {
    'dcampos/nvim-snippy',
    config = [[require('config.snippy')]],
  }

  use 'tpope/vim-surround'

  use {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }

  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = [[require('config.noice')]],
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = [[require('config.treesitter')]],
    run = function()
      -- Directly use libarary to avoid error on first install time.
      -- Set with_sync = true for CLI use.
      require('nvim-treesitter.install').update { with_sync = true }
    end,
  }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

