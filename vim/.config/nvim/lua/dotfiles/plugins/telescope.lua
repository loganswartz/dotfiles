local M = {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim/lua/plenary.nvim' },
    config = function()
        local builtins = require('telescope.builtin')
        local previewers = require('telescope.previewers')

        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-u>"] = false
                    },
                },
                layout_strategy = "flex",
                layout_config = {
                    flex = {
                        flip_columns = 130,
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
                    "--trim"
                }
            },
        }

        vim.keymap.set('n', '<leader>ff', builtins.find_files)
        vim.keymap.set('n', '<leader>fg', function() builtins.live_grep({
                additional_args = { "--pcre2" },
            })
        end)
        vim.keymap.set('n', '<leader>fb', builtins.buffers)
        vim.keymap.set('n', '<leader>fh', builtins.help_tags)
        vim.keymap.set('n', '<leader>fd', builtins.diagnostics)
        vim.keymap.set('n', '<leader>fs', builtins.git_status)
    end
}

return M
