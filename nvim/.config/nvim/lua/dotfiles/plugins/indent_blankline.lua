local M = {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    main = "ibl",
    opts = {
        indent = {
            char = "┆",
        },
        exclude = {
            filetypes = { "lazy" },
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
