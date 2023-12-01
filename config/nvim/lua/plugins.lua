require('packer').startup(function(use)

  -- Packer
  use 'wbthomason/packer.nvim'
  
  -- Color Scheme
  use 'gruvbox-community/gruvbox'

  -- Lualine
  use 'nvim-lualine/lualine.nvim'

  -- Telescope
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'kyazdani42/nvim-web-devicons' },
      { 'nvim-telescope/telescope-file-browser.nvim' }
    }
  }

  -- Treesitter for better code syntax highlighting
  -- Language parsers need to be installed independently with TSInstall <lang>
  -- We recommend updating the parsers on update
  use { 'nvim-treesitter/nvim-treesitter', run= ':TSUpdate'}
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'

  -- Comment shortcuts
  use 'numToStr/Comment.nvim'

  -- Git Worktrees
  use 'ThePrimeagen/git-worktree.nvim'

  -- Fugitive for Git
  use 'tpope/vim-fugitive'
  use 'kdheepak/lazygit.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Copilot
  use 'github/copilot.vim'

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
    end
  }

  if install_plugins then
    require('packer').sync()
  end
end)

if install_plugins then
  return
end

