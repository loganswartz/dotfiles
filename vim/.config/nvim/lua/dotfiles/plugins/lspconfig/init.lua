function ConfiguredLSPs()
    local need_npm = {
        'bashls',
        'dockerls',
        --[[ 'graphql', ]]
        --[[ 'intelephense', ]]
        'phpactor',
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
        --[[ 'phpstan', ]]
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
    dependencies = { 'williamboman/mason.nvim' },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local utils = require('dotfiles.plugins.lspconfig.utils')
        local options = utils.generate_opts()

        require('dotfiles.utils.helpers').register_lsp_attach(function(client, bufnr)
            if client.supports_method('textDocument/inlayHint') and vim.lsp.inlay_hint ~= nil then
                vim.lsp.inlay_hint(bufnr, true)

                if vim.lsp.inlay_hint then
                    vim.keymap.set("n", "<leader>h", function() vim.lsp.inlay_hint(0) end,
                        { desc = "Toggle Inlay Hints" })
                end
            else
                vim.keymap.set("n", "<leader>h",
                    function() vim.notify(client.name .. ' does not support inlay hints.') end,
                    { desc = "Toggle Inlay Hints" })
            end
        end)

        for _, lsp in pairs(ConfiguredLSPs()) do
            utils.setup_lsp(lsp, options)
        end
    end
}

return M
