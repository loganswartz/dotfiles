local M = {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
        },
    },
}

return M
