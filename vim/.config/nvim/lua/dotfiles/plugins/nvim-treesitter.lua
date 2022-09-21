local M = {
    'nvim-treesitter/nvim-treesitter',
    run = function() pcall(vim.cmd, 'TSUpdate') end,
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                'bash', 'c', 'c_sharp', 'cmake',
                'comment', 'cpp', 'css', 'dockerfile',
                'go', 'graphql', 'html', 'javascript',
                'jsdoc', 'json', 'json5', 'jsonc',
                'julia', 'lua', 'make', 'markdown',
                'perl', 'php', 'python', 'regex',
                'rst', 'ruby', 'rust', 'scss',
                'svelte', 'toml', 'tsx', 'typescript',
                'vim', 'yaml',
            },
            highlight = {
                enable = true,
                disable = { "c", "rust" },
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true
            },
            playground = {
                enable = false,
                disable = {},
                updatetime = 25,
                persist_queries = false,
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        }
    end
}

return M
