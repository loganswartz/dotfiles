local M = {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    version = false,
    config = function()
        local telescope = require('telescope')
        local builtins = require('telescope.builtin')
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

        vim.keymap.set('n', '<leader>ff', builtins.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtins.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtins.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtins.help_tags, {})
        vim.keymap.set('n', '<leader>fd', builtins.diagnostics, {})
        vim.keymap.set('n', '<leader>fs', builtins.git_status, {})
        vim.keymap.set('n', '<leader>fc', telescope.extensions.dir.live_grep, {})

        vim.api.nvim_create_user_command('FF', builtins.find_files, {})
    end
}

return M
