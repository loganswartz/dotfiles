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
        keys = {
            { '<leader>ds', function() require('updoc').search() end,           desc = 'Search docs' },
            { '<leader>dl', function() require('updoc').lookup() end,           desc = 'Lookup symbol' },
            { '<leader>dh', function() require('updoc').show_hover_links() end, desc = 'Show hover links' },
            { '<C-k>',      function() require('updoc').show_hover_links() end, desc = 'Show hover links' },
        },
        config = true,
    },
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            local home = vim.fn.expand("$HOME")
            require("chatgpt").setup({
                api_key_cmd = "cat " .. home .. "/chatgpt.txt",
                openai_params = {
                    model = "gpt-4-1106-preview",
                },
            })
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "VeryLazy",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-l>",
                    next = "<C-n>",
                    prev = "<C-b>",
                    dismiss = "<C-]>",
                },
            },
            panel = {
                enabled = true,
                auto_refresh = false,
            },
        },
    },

    -- UI / Highlighting
    "princejoogie/dir-telescope.nvim",
    {
        'nvim-telescope/telescope-media-files.nvim',
        dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    },
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
        "LintaoAmons/scratch.nvim",
        event = "VeryLazy",
    },
    {
        'sudormrfbin/cheatsheet.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
        event = 'VeryLazy',
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
    {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require('notify')
        end,
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
    {
        "chrisgrieser/nvim-genghis",
        dependencies = "stevearc/dressing.nvim",
        keys = {
            { "<leader>ws", function() require('genghis').duplicateFile() end },
        },
    },
    'arthurxavierx/vim-caser',
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },
    {
        'https://git.sr.ht/~reggie/licenses.nvim',
        config = function()
            require('licenses').setup({
                copyright_holder = 'Logan Swartzendruber',
                email = 'logan.swartzendruber@gmail.com',
                license = 'MIT',
            })
        end,
    },

    -- Formatting
    {
        'FooSoft/vim-argwrap',
        keys = {
            { 'gw', ':ArgWrap<CR>' },
        },
        config = function()
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
        keys = {
            {
                '<leader><space>',
                function() require('nvim-toggler').toggle() end,
                mode = { 'n', 'v' },
                desc = 'Toggle boolean value'
            },
        },
        config = function()
            require('nvim-toggler').setup({
                -- removes the default <leader>i keymap
                remove_default_keybinds = true,
            })
        end,
    },

    -- Git
    'tpope/vim-fugitive',
    {
        'rhysd/git-messenger.vim',
        keys = {
            { '<leader>b', ':GitMessenger<CR>', silent = true, noremap = true },
        },
        config = function()
            vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
            vim.g.git_messenger_popup_content_margins = false
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
        'linrongbin16/gitlinker.nvim',
        main = 'gitlinker',
        config = true,
        keys = {
            {
                '<leader>gy',
                '<cmd>GitLink<cr>',
                silent = true,
                noremap = true,
                desc = "Copy git permlink to clipboard",
                mode = { 'n', 'v' }
            },
        },
    },
    {
        '2kabhishek/co-author.nvim',
        dependencies = {
            'stevearc/dressing.nvim',
            'nvim-telescope/telescope.nvim',
        },
        cmd = { 'CoAuthor' },
    },

    -- Window Management
    'tpope/vim-vinegar',

    -- Navigation
    'wellle/targets.vim',
    {
        'joereynolds/place.vim',
        keys = {
            { 'ga', '<Plug>(place-insert)',          desc = 'Place character at <motion>' },
            { 'gb', '<Plug>(place-insert-multiple)', desc = 'Place multiple characters at <motion>' },
        },
    },
    {
        'julian/vim-textobj-variable-segment',
        dependencies = 'kana/vim-textobj-user',
    },
    {
        'gbprod/substitute.nvim',
        config = true,
        keys = {
            { "sx",  function() require('substitute.exchange').operator() end, noremap = true },
            { "sxx", function() require('substitute.exchange').line() end,     noremap = true },
            {
                "X",
                mode = "x",
                function() require('substitute.exchange').visual() end,
                noremap = true,
            },
            { "sxc", function() require('substitute.exchange').cancel() end, noremap = true },
        },
    },

    -- Colorschemes
    {
        'loganswartz/sunburn.nvim',
        dependencies = {
            'loganswartz/polychrome.nvim',
        },
        config = function()
            vim.cmd.colorscheme 'sunburn'
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
