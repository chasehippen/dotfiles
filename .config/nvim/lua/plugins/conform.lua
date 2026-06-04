-- ~/.config/nvim/lua/plugins/conform.lua
return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        python = { 'ruff_format' },
        go = { 'gofmt' },
        terraform = { 'terraform_fmt' },
        hcl = { 'terraform_fmt' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        lua = { 'stylua' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    })
  end,
}
