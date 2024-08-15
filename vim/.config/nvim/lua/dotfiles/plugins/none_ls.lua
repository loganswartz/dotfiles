local M = {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvimtools/none-ls-extras.nvim',
        'lukas-reineke/lsp-format.nvim',
    },
    config = function()
        local none_ls = require('null-ls')

        none_ls.setup({
            sources = {
                none_ls.builtins.formatting.gofmt,
                none_ls.builtins.formatting.sqlfmt,
                none_ls.builtins.formatting.prettierd.with({
                    disabled_filetypes = { 'yaml', 'markdown' },
                }),
                require('none-ls.diagnostics.eslint'),
                none_ls.builtins.code_actions.gitsigns,
                none_ls.builtins.code_actions.refactoring,
                none_ls.builtins.code_actions.ts_node_action,
                none_ls.builtins.hover.printenv,
            },
        })
    end,
}

return M
