local M = {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvimtools/none-ls-extras.nvim',
        {
            'ckolkey/ts-node-action',
            dependencies = { 'nvim-treesitter' },
            opts = {},
        },
    },
    config = function()
        local none_ls = require('null-ls')

        none_ls.setup({
            sources = {
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
