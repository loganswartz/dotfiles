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
        { '<leader>F', require('dotfiles.utils.formatting').LspFormat },
        { "<leader>h", require('dotfiles.plugins.lspconfig.utils').inlay_hints, desc = "Toggle Inlay Hints" },
        { 'K',         vim.lsp.buf.hover },
    },
    config = function()
        local lsp_utils = require('dotfiles.plugins.lspconfig.utils')
        local helpers = require('dotfiles.utils.helpers')
        local external = require('dotfiles.external')

        lsp_utils.define_diagnostic_indicators()
        lsp_utils.configure_pum()
        lsp_utils.register_autoformatting()
        lsp_utils.register_format_command()

        -- enable inlay hints by default
        helpers.register_lsp_attach(function(client, bufnr)
            lsp_utils.inlay_hints(bufnr, true)
        end)

        local options = lsp_utils.generate_opts()
        for _, lsp in ipairs(external.lsps:filter({ enabled = true })) do
            lsp_utils.setup_lsp(lsp, options)
        end
    end
}

return M
