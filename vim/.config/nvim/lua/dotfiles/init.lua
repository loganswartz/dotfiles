local M = {}

local LAZYPATH = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local SKIP_PLUGIN_LOAD = vim.env.SKIP_PLUGIN_LOAD == "1"

local function lazy_installed()
    return vim.uv.fs_stat(LAZYPATH)
end

local function bootstrap_lazy()
    if lazy_installed() then
        return false
    end

    vim.notify('Bootstrapping plugins....')
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        LAZYPATH,
    })

    return true
end

function M.setup()
    bootstrap_lazy()

    if lazy_installed() then
        vim.opt.rtp:prepend(LAZYPATH)

        require('lazy').setup('dotfiles.plugins', {
            defaults = { cond = not SKIP_PLUGIN_LOAD },
            checker = { enabled = true },
            --[[ ui = { ]]
            --[[     icons = { ]]
            --[[         plugin = '▲ ', ]]
            --[[     }, ]]
            --[[ }, ]]
        })
    end

    require('dotfiles.keymaps').setup()
end

return M
