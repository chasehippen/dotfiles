-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'kyazdani42/nvim-web-devicons',
    'nvim-telescope/telescope-file-browser.nvim',
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          theme = "ivy",
          mappings = { ["i"] = {}, ["n"] = {} },
        },
      },
    }
    telescope.load_extension('fzf')
    telescope.load_extension('git_worktree')
    telescope.load_extension('file_browser')
  end,
}

