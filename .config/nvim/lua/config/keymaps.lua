local map = vim.keymap.set

-- Map <Ctrl-w>= to invoke the vsplit Lua command
map('n', '<C-w>=', ':lua require("config.util").vsplit_file()<CR>', { noremap = true, silent = true, desc = "VSplit File" })

-- Map <Ctrl-w>- to invoke the split Lua command
map('n', '<C-w>-', ':lua require("config.util").split_file()<CR>', { noremap = true, silent = true, desc = "Split File" })

-- Format current file via conform
map('n', '<leader>tf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { noremap = true, silent = true, desc = "Format file" })

-- Telescope mappings
map('n', '<leader>ff', require('telescope.builtin').find_files)
map('n', '<leader>fg', require('telescope.builtin').live_grep)

-- Claude (CodeCompanion) mappings
map({ 'n', 'v' }, '<leader>ccc', '<cmd>CodeCompanionChat Toggle<CR>', { desc = "Toggle Claude chat" })
map('n', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    vim.cmd("CodeCompanion " .. input)
  end
end, { noremap = true, silent = true, desc = "Claude quick chat" })

-- LSP keymaps
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

map("n", "K", vim.lsp.buf.hover, { desc = "Hover doc" })

map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

map("n", "<leader>f", function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = "Format file" })
