local M = {
    'williamboman/mason.nvim',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'rcarriga/nvim-notify',
    },
    event = 'VeryLazy',
    config = function()
        local env = require("dotfiles.utils.env")
        if not env.has('npm') then
            vim.notify("'npm' was not found; some LSPs won't be installed.")
        end

        -- autoinstall LSPs
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = ConfiguredLSPs(),
            automatic_installation = true,
        })
        require('mason-tool-installer').setup({
            ensure_installed = ConfiguredTools()
        })
    end
}

return M
