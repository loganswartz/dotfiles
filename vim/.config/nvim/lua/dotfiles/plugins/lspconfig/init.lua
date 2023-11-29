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
    keys = {
        { '<leader>wa', vim.lsp.buf.add_workspace_folder },
        { '<leader>wr', vim.lsp.buf.remove_workspace_folder },
        { '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end },
        { '<leader>F', require("dotfiles.utils.formatting").LspFormat },
        { "<leader>h", require("dotfiles.plugins.lspconfig.utils").toggle_inlay_hints, desc = "Toggle Inlay Hints" },
        { 'K',         vim.lsp.buf.hover },
    },
    config = function()
        local utils = require('dotfiles.plugins.lspconfig.utils')

        utils.define_diagnostic_indicators()
        utils.configure_pum()
        utils.register_autoformatting()
        utils.register_format_command()

        -- enable inlay hints by default
        require('dotfiles.utils.helpers').register_lsp_attach(function(client, bufnr)
            vim.lsp.inlay_hint.enable(bufnr, true)
        end)

        local options = utils.generate_opts()
        for _, lsp in pairs(ConfiguredLSPs()) do
            utils.setup_lsp(lsp, options)
        end
    end
}

return M
