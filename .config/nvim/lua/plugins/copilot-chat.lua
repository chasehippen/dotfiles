-- ~/.config/nvim/lua/plugins/copilot-chat.lua
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'main',
  config = function()
    require("CopilotChat").setup { debug = true }
  end,
}

