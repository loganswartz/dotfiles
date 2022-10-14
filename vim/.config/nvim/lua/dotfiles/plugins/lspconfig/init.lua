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
        'sumneko_lua',
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
        utils.register_mason_tools_notification()

        utils.define_diagnostic_indicators()
        utils.configure_pum()
        utils.register_autoformatting()
        utils.register_format_command()

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            utils.register_keymaps(bufnr)
        end

        -- Setup lspconfig
        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

        -- add border to hover and signatureHelp floats
        local handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'solid' }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'solid' }),
        }

        local options = {
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
        }

        for _, lsp in pairs(ConfiguredLSPs()) do
            utils.setup_lsp(lsp, options)
        end
    end
}

return M
