-- ~/.config/nvim/lua/plugins/gruvbox.lua

return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  config = function()
    vim.o.termguicolors = true
    vim.cmd.colorscheme('gruvbox')
  end,
}
