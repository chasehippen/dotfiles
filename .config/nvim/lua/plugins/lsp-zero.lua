-- ~/.config/nvim/lua/plugins/lsp-zero.lua
return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local lsp = require('lsp-zero')

    -- extend lspconfig with lsp-zero defaults
    lsp.extend_lspconfig()

    -- Mason: external LSP/formatter installer
    require('mason').setup({})

    -- Mason-lspconfig: ensure these servers exist everywhere
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'gopls',
        'terraformls',
        'yamlls',
        'jsonls',
        'bashls',
        'ts_ls',
        'pyright',
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          lsp.default_setup(server_name)
        end,
      },
    })
  end,
}
