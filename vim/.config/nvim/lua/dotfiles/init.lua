local M = {}

local LAZYREPO = "https://github.com/folke/lazy.nvim.git"
local LAZYPATH = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local SKIP_PLUGIN_LOAD = vim.env.SKIP_PLUGIN_LOAD == "1"

local function lazy_installed()
    return (vim.uv or vim.loop).fs_stat(LAZYPATH)
end

local function bootstrap()
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        LAZYREPO,
        LAZYPATH,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
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
    require('dotfiles.diagnostics').setup()
end

return M
