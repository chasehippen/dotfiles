-- ~/.config/nvim/lua/plugins/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      highlight = { enable = true },
      ensure_installed = {
        'javascript', 'typescript', 'tsx',
        'css', 'html', 'json', 'yaml', 'toml',
        'go', 'python', 'lua', 'hcl', 'terraform',
        'markdown', 'markdown_inline',
        'sql', 'dockerfile', 'bash',
      },
    }
  end,
}

