local M = {}

function M.open_file_with_completion(split_command)
    local file_path = vim.fn.input("File to open: ", vim.fn.getcwd() .. "/", "file")
    if file_path ~= "" then
        vim.cmd(split_command .. " " .. file_path)
    end
end

function M.vsplit_file()
    M.open_file_with_completion('vsplit')
end

function M.split_file()
    M.open_file_with_completion('split')
end

function M.format_terraform()
  vim.cmd('w')

  local current_file = vim.fn.expand('%:p')
  local cmd = string.format('silent !terraform fmt %q', current_file)

  vim.cmd(cmd)
  vim.cmd('edit!')
end

return M

