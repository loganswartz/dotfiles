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
        {
            '<C-h>',
            function()
                local root = vim.fs.root(0, '.git')
                local http_dir = vim.fs.joinpath(root, '.http')

                if vim.fn.isdirectory(http_dir) then
                    vim.cmd.split(http_dir)
                else
                    vim.notify('No .http directory found at "' .. http_dir .. '"!', vim.log.levels.WARN)
                end
            end,
        }
    },
}
