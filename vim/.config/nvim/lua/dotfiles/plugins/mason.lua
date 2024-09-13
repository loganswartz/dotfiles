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
        local helpers = require("dotfiles.utils.helpers")
        local external = require('dotfiles.external')

        if not env.has('npm') then
            vim.notify("'npm' was not found; some LSPs won't be installed.")
        end

        local lsps = vim.tbl_keys(helpers.where(external.lsps, { install = true }))
        local tools = vim.tbl_keys(helpers.where(external.tools, { install = true }))

        -- autoinstall LSPs
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = lsps,
            automatic_installation = true,
        })
        require('mason-tool-installer').setup({
            ensure_installed = tools,
        })
    end
}

return M
