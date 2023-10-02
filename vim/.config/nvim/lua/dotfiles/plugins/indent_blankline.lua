local M = {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    keys = {
        { 'za', 'za<CMD>IndentBlanklineRefresh<CR>' },
        { 'zA', 'zA<CMD>IndentBlanklineRefresh<CR>' },
        { 'zo', 'zo<CMD>IndentBlanklineRefresh<CR>' },
        { 'zO', 'zO<CMD>IndentBlanklineRefresh<CR>' },
        { 'zR', 'zR<CMD>IndentBlanklineRefresh<CR>' },
    },
    main = "ibl",
    opts = {
        indent = {
            char = "┆",
        },
        exclude = {
            filetype = { "lazy" },
        },
        scope = {
            enabled = true,
            char = "│",
            show_start = false,
            show_end = false,
        },
    },
}

return M
