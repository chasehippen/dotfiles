-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      highlight = { enable = true },
      ensure_installed = {
        'javascript', 'typescript', 'css', 'html', 'json', 'yaml',
        'go', 'python', 'lua', 'hcl', 'terraform',
      },
    }
  end,
}

