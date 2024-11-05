require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  ensure_installed = {
    'javascript',
    'typescript',
    'css',
    'html',
    'json',
    'yaml',
    'go',
    'python',
    'lua',
    'hcl',
    'terraform',
  },
})
