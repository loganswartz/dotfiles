function ConfiguredLSPs()
    local need_npm = {
        'bashls',
        'dockerls',
        --[[ 'graphql', ]]
        'intelephense',
        --[[ 'phpactor', ]]
        'jsonls',
        'pyright',
        'svelte',
        'tsserver',
        'vimls',
        'yamlls',
    }
    local other = {
        'marksman',
        'rust_analyzer',
        'lua_ls',
    }

    local env = require("dotfiles.utils.env")
    if env.has('npm') then
        return vim.tbl_flatten({ need_npm, other })
    else
        return other
    end
end

function ConfiguredTools()
    local need_npm = {
        'black',
        'prettierd',
        'php-debug-adapter',
    }
    local other = {
        'sqlfmt',
    }

    local env = require("dotfiles.utils.env")
    if env.has('npm') then
        return vim.tbl_flatten({ need_npm, other })
    else
        return other
    end
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
    after = { 'mason.nvim', 'neodev.nvim' },
    config = function()
        vim.notify = require('notify')
        local utils = require('dotfiles.plugins.lspconfig.utils')
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

        local options = utils.generate_opts()

        for _, lsp in pairs(ConfiguredLSPs()) do
            utils.setup_lsp(lsp, options)
        end
    end
}

return M
