local M = {}

function M.open_file_with_completion(split_command)
    local file_path = vim.fn.input("File to open: ", vim.fn.getcwd() .. "/", "file")
    if file_path ~= "" then
        vim.cmd(split_command .. " " .. file_path)
    end
end

return M

