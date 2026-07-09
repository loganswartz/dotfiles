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
            { out, "WarningMsg" },
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

    require("dotfiles.options").setup()
    require("dotfiles.commands").setup()
    require("dotfiles.keymaps").setup()
    require("dotfiles.diagnostics").setup()
    require("dotfiles.filetypes").setup()
    require("dotfiles.lsp").setup()

    vim.opt.rtp:prepend(LAZYPATH)

    require("lazy").setup({
        { import = "dotfiles.plugins" },
        {
            import = "machine.plugins",
            cond = function()
                local ok, _ = pcall(require, "machine.plugins")
                return ok
            end,
        },
    }, {
        defaults = { cond = not SKIP_PLUGIN_LOAD },
        checker = { enabled = true },
        rocks = { enabled = false },
        dev = {
            path = "~/development/projects",
            patterns = { "loganswartz" },
            fallback = true,
        },
        performance = {
            rtp = {
                -- machine-local overrides
                paths = { "$HOME/.config/nvim.d" },
            },
        },
    })

    -- machine-local overrides
    local ok, machine = pcall(require, "machine")
    if ok and machine.setup ~= nil then
        machine.setup()
    end
end

return M
