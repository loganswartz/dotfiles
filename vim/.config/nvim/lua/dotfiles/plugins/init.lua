return {
    -- LSP
    {
        'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = function()
            local rt = require("rust-tools")

            local utils = require('dotfiles.plugins.lspconfig.utils')
            local options = utils.generate_opts()

            rt.setup({
                server = options,
            })
        end
    },
    {
        'saecki/crates.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        main = 'crates',
        config = true,
    },
    'jose-elias-alvarez/typescript.nvim',
    'folke/neodev.nvim',
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" }
    },
    {
        'loganswartz/updoc.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            local updoc = require('updoc')
            updoc.setup()

            vim.keymap.set('n', '<leader>ds', updoc.search)
            vim.keymap.set('n', '<C-k>', updoc.show_hover_links)
        end,
    },

    -- UI / Highlighting
    "princejoogie/dir-telescope.nvim",
    {
        'stevearc/dressing.nvim',
        event = "VeryLazy",
        opts = {
            input = {
                get_config = function(opts)
                    if opts.prompt == require('dotfiles.keymaps').save_copy_prompt then
                        return {
                            relative = 'win',
                        }
                    end
                end,
            },
            select = {
                backend = { "telescope" },
            }
        },
    },
    'rafcamlet/nvim-luapad',
    {
        'sudormrfbin/cheatsheet.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        }
    },
    {
        'nacro90/numb.nvim',
        main = 'numb',
        config = true,
        event = 'VeryLazy',
    },
    {
        'norcalli/nvim-colorizer.lua',
        main = 'colorizer',
        config = true,
        event = 'VeryLazy',
    },
    'ryanoasis/vim-devicons',
    {
        'lukas-reineke/virt-column.nvim',
        config = function()
            require("virt-column").setup()
            vim.cmd [[ hi! link VirtColumn Comment ]]
        end,
    },
    'loganswartz/vim-squint',

    -- Completion
    {
        'ray-x/lsp_signature.nvim',
        opts = {
            hint_enable = false,
        },
    },
    'tpope/vim-surround',
    'tpope/vim-speeddating',
    'tpope/vim-eunuch',
    'arthurxavierx/vim-caser',
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },

    -- Formatting
    {
        'FooSoft/vim-argwrap',
        config = function()
            vim.keymap.set('n', 'gw', ':ArgWrap<CR>')
            vim.g.argwrap_tail_comma = true
        end,
    },
    {
        'tibabit/vim-templates',
        config = function()
            vim.g.tmpl_search_paths = { vim.fn.stdpath('config') .. '/templates' }
        end,
    },
    {
        'nguyenvukhang/nvim-toggler',
        config = function()
            require('nvim-toggler').setup({
                -- removes the default <leader>i keymap
                remove_default_keybinds = true,
            })
            vim.keymap.set({ 'n', 'v' }, '<leader><space>', require('nvim-toggler').toggle)
        end,
    },

    -- Git
    'tpope/vim-fugitive',
    {
        'rhysd/git-messenger.vim',
        config = function()
            vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
            vim.g.git_messenger_popup_content_margins = false
            vim.keymap.set('n', '<leader>b', ':GitMessenger<CR>', { silent = true, noremap = true })
        end,
    },
    {
        'tveskag/nvim-blame-line',
        config = function()
            vim.g.blameLineGitFormat = ' [%an • %as] %s'
            vim.keymap.set('n', '<leader>B', ':ToggleBlameLine<CR>', { silent = true, noremap = true })
        end,
    },
    {
        'ruifm/gitlinker.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        main = 'gitlinker',
        config = true,
    },

    -- Window Management
    'tpope/vim-vinegar',

    -- Navigation
    'wellle/targets.vim',
    {
        'joereynolds/place.vim',
        config = function()
            vim.keymap.set('n', 'ga', '<Plug>(place-insert)')
            vim.keymap.set('n', 'gb', '<Plug>(place-insert-multiple)')
        end,
    },
    {
        'julian/vim-textobj-variable-segment',
        dependencies = 'kana/vim-textobj-user',
    },

    -- Colorschemes
    {
        'loganswartz/sunburn.nvim',
        dependencies = {
            'loganswartz/polychrome.nvim',
        },
        config = function()
            vim.cmd.colorscheme('sunburn')
        end,
    },
    {
        'loganswartz/selenized.nvim',
        dependencies = {
            'rktjmp/lush.nvim',
        },
        config = function()
            vim.g.selenized_variant = 'bw'
        end,
    },

    -- Misc
    'dstein64/vim-startuptime',
    'lambdalisue/suda.vim',
    'jghauser/mkdir.nvim',
}
