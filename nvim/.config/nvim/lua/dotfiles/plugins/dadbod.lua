local SQL_FILETYPES = { 'sql', 'mysql', 'plsql' }

return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        { 'tpope/vim-dadbod',                     lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    keys = {
        { '<leader>du', ':DBUIToggle<CR>',        ft = SQL_FILETYPES, silent = true },
        { '<leader>ds', ':DBUI<CR>',              ft = SQL_FILETYPES, silent = true },
        { '<leader>dc', ':DBUIAddConnection<CR>', ft = SQL_FILETYPES, silent = true },
        { '<leader>df', ':DBUIFindBuffer<CR>',    ft = SQL_FILETYPES, silent = true },
        {
            '<localleader><space>',
            require('dotfiles.plugins.treesitter.utils').execute_query_under_cursor,
            ft = SQL_FILETYPES,
            silent = true
        },
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_auto_execute_table_helpers = 1
        vim.g.db_ui_execute_on_save = 0
    end,
}
