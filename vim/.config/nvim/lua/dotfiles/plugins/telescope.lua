local M = {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Telescope",
    version = false,
    keys = {
        -- meta
        { '<leader>ft', require('telescope.builtin').builtin,          desc = 'Open Telescope' },
        -- files
        { '<leader>ff', require('telescope.builtin').find_files,       desc = 'Find files' },
        { '<leader>fg', require('telescope.builtin').live_grep,        desc = 'Live grep in current directory' },
        { '<leader>fs', require('telescope').extensions.dir.live_grep, desc = 'Live Grep in a subdirectory' },
        -- LSP
        { '<leader>fd', require('telescope.builtin').diagnostics,      desc = 'Show all diagnostics' },
        { '<leader>gd', require("telescope.builtin").lsp_definitions,  desc = 'Go to Definition' },
        {
            '<leader>gD',
            function()
                require("telescope.builtin").lsp_definitions({ jump_type = 'vsplit' })
            end,
            desc = 'Go to Definition in split'
        },
        { '<leader>gi', require("telescope.builtin").lsp_implementations,  desc = 'Go to Implementation' },
        { '<leader>gt', require("telescope.builtin").lsp_type_definitions, desc = 'Go to Definition' },
        { '<leader>gr', require("telescope.builtin").lsp_references,       desc = 'Go to References' },
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        --[[ { '<leader>gD', vim.lsp.buf.declaration,                           desc = 'LSP Type Declarations' }, ]]
        { '<leader>fa', vim.lsp.buf.code_action,                           desc = 'LSP Code Actions' },
        { '<leader>r',  vim.lsp.buf.rename,                                desc = 'LSP Rename' },
        { '[g',         vim.diagnostic.goto_prev,                          desc = 'Go to previous diagnostic' },
        { ']g',         vim.diagnostic.goto_next,                          desc = 'Go to next diagnostic' },
        {
            '<leader>fbd',
            function()
                require('telescope.builtin').diagnostics({ bufnr = 0 })
            end,
            desc = 'Show diagnostics for buffer'
        },
        -- vim
        { '<leader>fh',  require('telescope.builtin').help_tags,  desc = 'Search help tags' },
        { '<leader>fbb', require('telescope.builtin').buffers,    desc = 'Show open buffers' },
        -- git
        { '<leader>gs',  require('telescope.builtin').git_status, desc = 'Show git status' },
        { '<leader>fl',  require('telescope.builtin').reloader,   desc = 'Reload lua modules' },
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
        telescope.load_extension('media_files')
        vim.api.nvim_create_user_command('FF', require('telescope.builtin').find_files, {})
    end
}

return M
