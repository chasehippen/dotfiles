-- This file is automatically loaded by lazyvim.config.init

local map = vim.keymap.set

-- Map <Ctrl-w>= to invoke the vsplit Lua command
map('n', '<C-w>=', ':lua require("util").vsplit_file()<CR>', { noremap = true, silent = true, desc = "VSplit File" })

-- Map <Ctrl-w>- to invoke the split Lua command
map('n', '<C-w>-', ':lua require("util").split_file()<CR>', { noremap = true, silent = true, desc = "Split File" })

-- Map the function to a key combination (for example, <leader>tf)
map('n', '<leader>tf', ':lua require("util").format_terraform()<CR>', { noremap = true, silent = true, desc = "Format Terraform" })

-- Add mapping for CopilotChat Quick chat
map('n', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, { noremap = true, silent = true, desc = "CopilotChat - Quick chat" })
