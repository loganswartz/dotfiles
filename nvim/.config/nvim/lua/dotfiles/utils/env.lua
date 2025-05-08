local M = {}

function M.have(exec)
    return vim.fn.executable(exec) == 1
end

--- Get the path of my dotfiles root
function M.dotfiles_root()
    local this_file = debug.getinfo(1, "S").source:sub(2)
    local result = vim.system({ "realpath", this_file }):wait()

    return vim.fs.root(result.stdout, ".git")
end

--- Get the path of the lua runtime directory for my dotfiles
function M.dotfiles_lua_runtime_root()
    return vim.fs.joinpath(M.dotfiles_root(), "nvim", ".config", "nvim", "lua")
end

--- Get the path of my 'dotfiles' lua module
function M.dotfiles_lua_module_root()
    return vim.fs.joinpath(M.dotfiles_lua_runtime_root(), "dotfiles")
end

--- Get the path of the dir used to store mason packages
function M.mason_root()
    return vim.fn.expand("$MASON") or vim.fn.stdpath("data") .. "/mason"
end

--- Get the path of the dir used to store mason packages
---
---@param pkg string|nil
function M.mason_pkg_dir(pkg)
    local base = M.mason_root() .. "/packages"
    if pkg == nil then
        return base
    end

    return base .. "/" .. pkg
end

--- Get the full path of a mason-installed binary
---
---@param binary_name string
function M.mason_bin(binary_name)
    return M.mason_root() .. "/bin/" .. binary_name
end

return M
