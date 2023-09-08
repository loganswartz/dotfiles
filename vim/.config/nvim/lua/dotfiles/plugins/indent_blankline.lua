local M = {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
        require("indent_blankline").setup {
            char = "┆",
            space_char_blankline = " ",
            buftype_exclude = { "terminal" },
            filetype_exclude = { "lazy" },
            use_treesitter = true,
            show_current_context = true,
            show_first_indent_level = true,
            show_trailing_blankline_indent = false,
        }
        vim.o.listchars = "trail:·,tab:┆─,nbsp:␣"
        vim.o.list = true
        -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/265#issuecomment-942000366
        local opts = { silent = true, noremap = true }
        vim.keymap.set('n', 'za', 'za:IndentBlanklineRefresh<CR>', opts)
        vim.keymap.set('n', 'zA', 'zA:IndentBlanklineRefresh<CR>', opts)
        vim.keymap.set('n', 'zo', 'zo:IndentBlanklineRefresh<CR>', opts)
        vim.keymap.set('n', 'zO', 'zO:IndentBlanklineRefresh<CR>', opts)
        vim.keymap.set('n', 'zR', 'zR:IndentBlanklineRefresh<CR>', opts)
    end
}

return M
