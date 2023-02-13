function ConfiguredLSPs()
    return {
        'bashls',
        'dockerls',
        --[[ 'graphql', ]]
        'intelephense',
        'jsonls',
        'marksman',
        'pyright',
        'rust_analyzer',
        'lua_ls',
        'tsserver',
        'vimls',
        'yamlls',
    }
end

local M = {
    'neovim/nvim-lspconfig',
    requires = {
        {
            'williamboman/mason.nvim',
            requires = {
                'williamboman/mason-lspconfig.nvim',
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                'rcarriga/nvim-notify',
            },
        },
    },
    after = 'mason.nvim',
    config = function()
        vim.notify = require('notify')
        local utils = require('dotfiles.plugins.lspconfig.utils')

        -- autoinstall LSPs
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = ConfiguredLSPs(),
            automatic_installation = true,
        })
        require('mason-tool-installer').setup({
            ensure_installed = { 'black', 'prettierd', 'php-debug-adapter' }
        })

        local options = utils.generate_opts()

        for _, lsp in pairs(ConfiguredLSPs()) do
            utils.setup_lsp(lsp, options)
        end
    end
}

return M
