return require('packer').startup({function()

    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'

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

    use { "nvim-telescope/telescope-file-browser.nvim" }

    -- Color scheme
    use 'gruvbox-community/gruvbox'

    -- Git Worktrees
    use 'ThePrimeagen/git-worktree.nvim'

    -- Fugitive for Git
    use 'tpope/vim-fugitive'
    use 'kdheepak/lazygit.nvim'
    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' }
    }

    -- Status line
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- Some help
    use 'vim-utils/vim-man'

    -- LSP and completion
    -- Language servers need to be installed
    -- with :LspInstall <lang> and the client needs to be
    -- attached to them, check :h lsp
    -- use 'williamboman/nvim-lsp-installer' -- setup plugin ???
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/nvim-cmp' -- Auto-completion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-buffer' -- Buffer source for nvim-cmp
    use 'hrsh7th/cmp-path' -- Path source for nvim-cmp
    use 'hrsh7th/cmp-cmdline' -- Cmdline source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippet plugin
    use 'hrsh7th/cmp-nvim-lua'
    use 'onsails/lspkind-nvim'

    -- Treesitter for better code syntax highlighting
    -- Language parsers need to be installed independently with TSInstall <lang>
    -- We recommend updating the parsers on update
    use { 'nvim-treesitter/nvim-treesitter', run= ':TSUpdate'}
    -- Additional textobjects for treesitter
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- floaterm
    use 'voldikss/vim-floaterm'

    use { "anuvyklack/windows.nvim",
       requires = {
          "anuvyklack/middleclass",
          "anuvyklack/animation.nvim"
      },
       config = function()
          vim.o.winwidth = 10
          vim.o.winminwidth = 10
          vim.o.equalalways = false
          require('windows').setup()
       end
    }

end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}})
