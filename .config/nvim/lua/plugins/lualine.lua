-- Disable default mode line
vim.opt.showmode = false

-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup()
  end,
}

