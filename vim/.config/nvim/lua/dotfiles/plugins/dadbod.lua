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
        { '<leader>du', ':DBUIToggle<CR>',        silent = true },
        { '<leader>ds', ':DBUI<CR>',              silent = true },
        { '<leader>dc', ':DBUIAddConnection<CR>', silent = true },
        { '<leader>df', ':DBUIFindBuffer<CR>',    silent = true },
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_auto_execute_table_helpers = 1

        vim.cmd [[
            autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
        ]]
    end,
}
