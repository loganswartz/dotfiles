local M = {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'folke/lazydev.nvim',
    },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
        { '<leader>wa', vim.lsp.buf.add_workspace_folder },
        { '<leader>wr', vim.lsp.buf.remove_workspace_folder },
        { '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end },
        { "<leader>h", require('dotfiles.plugins.lspconfig.utils').inlay_hints, desc = "Toggle Inlay Hints" },
        { 'K',         vim.lsp.buf.hover },
    },
    config = function()
        local lsp_utils = require('dotfiles.plugins.lspconfig.utils')
        local helpers = require('dotfiles.utils.helpers')
        local external = require('dotfiles.external')

        -- enable inlay hints by default
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                lsp_utils.inlay_hints(args.buf, true)
            end,
        })

        local lsps = vim.tbl_keys(helpers.where(external.lsps, { setup = true }))
        local options = lsp_utils.generate_opts()

        for _, lsp in ipairs(lsps) do
            lsp_utils.setup_lsp(lsp, options)
        end
    end
}

return M
