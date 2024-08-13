return {
    'mistweaverco/kulala.nvim',
    init = function()
        vim.filetype.add({
            extension = {
                ['http'] = 'http',
            },
        })
    end,
    config = function()
        require('kulala').setup()
    end,
    keys = {
        { '<leader>e', function() require('kulala').set_selected_env() end },
        { '<C-l>',     function() require('kulala').run() end },
    },
}
