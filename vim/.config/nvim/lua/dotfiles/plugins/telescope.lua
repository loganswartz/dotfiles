local M = {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    version = false,
    keys = {
        { '<leader>ff', function() require('telescope.builtin').find_files() end },
        { '<leader>fg', function() require('telescope.builtin').live_grep() end },
        { '<leader>fb', function() require('telescope.builtin').buffers() end },
        { '<leader>fh', function() require('telescope.builtin').help_tags() end },
        { '<leader>fd', function() require('telescope.builtin').diagnostics() end },
        { '<leader>fs', function() require('telescope.builtin').git_status() end },
        { '<leader>fc', function() require('telescope').extensions.dir.live_grep() end },
    },
    config = function()
        local telescope = require('telescope')
        local previewers = require('telescope.previewers')

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false
                    },
                },
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 160,
                    },
                },
                set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                file_previewer = previewers.vim_buffer_cat.new,
                grep_previewer = previewers.vim_buffer_vimgrep.new,
                qflist_previewer = previewers.vim_buffer_qflist.new,
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--trim",
                    "--pcre2",
                }
            },
        })
        telescope.load_extension('dir')
        vim.api.nvim_create_user_command('FF', require('telescope.builtin').find_files, {})
    end
}

return M
