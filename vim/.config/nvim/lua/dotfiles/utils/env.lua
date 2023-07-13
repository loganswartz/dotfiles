local M = {}

function M.has(program)
    return vim.fn.executable(program) == 1
end

return M
