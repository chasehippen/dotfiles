local M = {}

function M.open_file_with_completion(split_command)
    local file_path = vim.fn.input("File to open: ", vim.fn.getcwd() .. "/", "file")
    if file_path ~= "" then
        vim.cmd(split_command .. " " .. file_path)
    end
end

function M.format_terraform()
    -- Save the buffer
    vim.api.nvim_command('execute "w"')

    local current_file = vim.fn.expand('%:p')
    local command = 'silent !terraform fmt ' .. current_file

    -- Execute the Terraform formatting command without opening a terminal buffer
    vim.api.nvim_command(command)
end

return M
