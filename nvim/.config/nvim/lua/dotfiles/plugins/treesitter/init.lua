local M = {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'asm', 'awk', 'bash', 'c', 'c_sharp',
                'cmake', 'comment', 'commonlisp', 'cpp',
                'css', 'csv', 'diff', 'dockerfile',
                'git_config', 'git_rebase', 'gitattributes',
                'gitcommit', 'gitignore', 'go', 'graphql',
                'html', 'htmldjango', 'http', 'ini',
                'javascript', 'jsdoc', 'json', 'json5',
                'jsonc', 'julia', 'lua', 'luadoc', 'luap',
                'luau', 'make', 'markdown', 'perl', 'php',
                'phpdoc', 'python', 'regex', 'rst', 'ruby',
                'rust', 'scss', 'ssh_config', 'sql',
                'svelte', 'toml', 'tmux', 'tsx',
                'typescript', 'vim', 'vimdoc', 'yaml',
                'xml',
            },
            highlight = {
                enable = true,
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
            autotag = {
                enable = true,
            },
        })

        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade"
        }
    end,
}

return M