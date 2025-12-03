local map = vim.keymap.set

-- Map <Ctrl-w>= to invoke the vsplit Lua command
map('n', '<C-w>=', ':lua require("config.util").vsplit_file()<CR>', { noremap = true, silent = true, desc = "VSplit File" })

-- Map <Ctrl-w>- to invoke the split Lua command
map('n', '<C-w>-', ':lua require("config.util").split_file()<CR>', { noremap = true, silent = true, desc = "Split File" })

-- Map the function to a key combination (for example, <leader>tf)
map('n', '<leader>tf', ':lua require("config.util").format_terraform()<CR>', { noremap = true, silent = true, desc = "Format Terraform" })

-- Telescope mappings
map('n', '<leader>ff', require('telescope.builtin').find_files)
map('n', '<leader>fg', require('telescope.builtin').live_grep)

-- Add mapping for CopilotChat Quick chat
map('n', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, { noremap = true, silent = true, desc = "CopilotChat - Quick chat" })

-- LSP keymaps
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

map("n", "K", vim.lsp.buf.hover, { desc = "Hover doc" })

map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

map("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })
