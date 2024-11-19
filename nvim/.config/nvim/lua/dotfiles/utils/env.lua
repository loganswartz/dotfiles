local M = {}

function M.have(exec)
    return vim.fn.executable(exec) == 1
end

--- Get the path of my dotfiles root
function M.dotfiles_root()
    local this_file = debug.getinfo(1, "S").source:sub(2)
    local result = vim.system({ 'realpath', this_file }):wait()

    return vim.fs.root(result.stdout, '.git')
end

--- Get the path of the lua runtime directory for my dotfiles
function M.dotfiles_lua_runtime_root()
    return vim.fs.joinpath(M.dotfiles_root(), 'vim', '.config', 'nvim', 'lua')
end

--- Get the path of my 'dotfiles' lua module
function M.dotfiles_lua_module_root()
    return vim.fs.joinpath(M.dotfiles_lua_runtime_root(), 'dotfiles')
end

return M
