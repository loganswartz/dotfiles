local M = {}

local LAZYPATH = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local SKIP_PLUGIN_LOAD = vim.env.SKIP_PLUGIN_LOAD == "1"

local function lazy_installed()
    return (vim.uv or vim.loop).fs_stat(LAZYPATH)
end

local function bootstrap()
    vim.notify('Setting up....')
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        LAZYPATH,
    })
end

function M.setup()
    if not lazy_installed() then
        bootstrap()
    end

    vim.opt.rtp:prepend(LAZYPATH)
    require('lazy').setup('dotfiles.plugins', {
        defaults = { cond = not SKIP_PLUGIN_LOAD },
        checker = { enabled = true },
        dev = {
            path = "~/development/projects",
            patterns = { "loganswartz" },
            fallback = true,
        },
    })

    require('dotfiles.keymaps').setup()
end

return M
