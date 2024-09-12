local M = {}

function M.has(program)
    return vim.fn.executable(program) == 1
end

function M.dotfiles_runtime_root()
    local this_file = debug.getinfo(1, "S").source:sub(2)

    return this_file:match("(.*)/dotfiles/utils/env.lua")
end

function M.dotfiles_root()
    return M.dotfiles_runtime_root() .. '/dotfiles'
end

return M
