-- cwd term
vim.api.nvim_set_keymap('n', '<leader>ft', [[<cmd>:FloatermToggle<CR>]], { noremap = true, silent = true })
-- lazygit
vim.api.nvim_set_keymap('n', '<leader>gg', [[<cmd>:FloatermNew --name=lg --height=99 --width=150 lazygit<CR>]], { noremap = true, silent = true })
-- sleep
vim.api.nvim_set_keymap('n', '<leader>cff', [[<cmd>:FloatermNew --name=sleep caffeinate -d<CR>]], { noremap = true, silent = true })
