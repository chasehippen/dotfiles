vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30

vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Create a Lua command to prompt for a file with completion and open it in a vsplit
vim.cmd("command! -nargs=0 VSplitFile lua require('util').open_file_with_completion('vsplit')")

-- Create a Lua command to prompt for a file with completion and open it in a split
vim.cmd("command! -nargs=0 SplitFile lua require('util').open_file_with_completion('split')")

-- Map <Ctrl-w>= to invoke the vsplit Lua command
vim.api.nvim_set_keymap('n', '<C-w>=', ':VSplitFile<CR>', { noremap = true, silent = true })

-- Map <Ctrl-w>- to invoke the split Lua command
vim.api.nvim_set_keymap('n', '<C-w>-', ':SplitFile<CR>', { noremap = true, silent = true })

-- Source the util.lua file
local terraform = require('util')

-- Map the function to a key combination (for example, <leader>tf)
vim.api.nvim_set_keymap('n', '<leader>tf', ':lua require("util").format_terraform()<CR>', { noremap = true, silent = true })

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = false

-- Auto install Packer if not exists
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end

-- Auto update plugins and compile packer when changes are made on plugins.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- In your existing set_formatoptions function, ensure 'r' is not included if you do not want auto comments
function set_formatoptions()
  local bufnr = vim.fn.bufnr("%")
  -- Remove 'o' and 'r' flags to stop automatic commenting on new lines
  vim.bo[bufnr].formatoptions = vim.bo[bufnr].formatoptions:gsub('[or]', '') 
end

-- Use this function to return the appropriate key sequence for the Enter key
function _G.check_comment_enter()
  local col = vim.fn.col('.') -- Get the current cursor column
  local line = vim.fn.getline('.') -- Get the current line

  -- Check if the cursor is at the end of a comment line
  if string.find(line, '^%s*--.*$') and col == #line + 1 then
    -- Insert a newline and avoid auto-commenting by not returning comment characters
    return "\n"
  else
    -- Insert a newline and continue auto-commenting if 'r' is set in formatoptions
    return "\n"
  end
end

-- Map the Enter key in insert mode to use the Lua function
vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.check_comment_enter()', {expr = true, noremap = true, silent = true})

-- Define an autocmd group named "FormatOptions"
vim.cmd([[
  augroup FormatOptions
    autocmd!
    autocmd BufEnter * lua set_formatoptions()
  augroup END
]])

-- Install plugins
require('plugins')

-- Plugin customizations
require('user')

