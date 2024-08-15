return {
    -- LSP
    {
        "lukas-reineke/lsp-format.nvim",
        keys = {
            { '<leader>F', ":Format<CR>", silent = true },
        },
        config = function()
            require('lsp-format').setup({
                exclude = { 'marksman', 'typescript-tools' },
            })

            -- ensure that the buffer is formatted before saving
            vim.cmd [[cabbrev wq execute "Format sync" <bar> wq]]
        end,
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        lazy = false,
    },
    {
        'saecki/crates.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        main = 'crates',
        config = true,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            settings = {
                tsserver_file_preferences = {
                    includeCompletionsForModuleExports = true,
                    quotePreference = "auto",
                    includeInlayParameterNameHints = "all",
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true
                },
                expose_as_code_action = "all",
            },
        },
    },
    'folke/neodev.nvim',
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        }
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
            select = {
                backend = { "telescope" },
            }
        },
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require('lsp_lines').setup()

            vim.diagnostic.config({
                float = { source = true },
                virtual_text = false,
                virtual_lines = {
                    highlight_whole_line = true,
                },
            })

            -- vim.api.nvim_create_autocmd('FileType', {
            --     pattern = 'lazy',
            --     callback = function()
            --         vim.diagnostic.config({
            --             virtual_text = true,
            --             virtual_lines = false,
            --         })
            --     end
            -- })

            -- vim.keymap.set(
            --     "",
            --     "<leader>l",
            --     require("lsp_lines").toggle,
            --     { desc = "Toggle lsp_lines" }
            -- )
        end,
    },
    {
        "lewis6991/hover.nvim",
        keys = {
            { "K",  function() require("hover").hover() end,        desc = "hover.nvim" },
            { "gK", function() require("hover").hover_select() end, desc = "hover.nvim (select)" },
            {
                "<C-p>",
                function() require("hover").hover_switch("previous") end,
                desc = "hover.nvim (previous source)"
            },
            {
                "<C-n>",
                function() require("hover").hover_switch("next") end,
                desc = "hover.nvim (next source)"
            },

            -- Mouse support
            { '<MouseMove>', function() require('hover').hover_mouse() end, { desc = "hover.nvim (mouse)" } },
        },
        config = function()
            require("hover").setup {
                init = function()
                    require("hover.providers.lsp")
                    require('hover.providers.gh')
                    require('hover.providers.gh_user')
                    require('hover.providers.jira')
                    require('hover.providers.man')
                    -- require('hover.providers.dictionary')
                end,
                preview_opts = {
                    border = 'single'
                },
                -- Whether the contents of a currently open hover window should be moved
                -- to a :h preview-window when pressing the hover keymap.
                preview_window = false,
                title = true,
                -- mouse_providers = {
                --     'LSP'
                -- },
                -- mouse_delay = 1000
            }

            -- vim.o.mousemoveevent = true
        end
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
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true
    },
    'tpope/vim-speeddating',
    {
        "chrisgrieser/nvim-genghis",
        dependencies = "stevearc/dressing.nvim",
        lazy = false,
        keys = {
            { "<leader>ws", function() require('genghis').duplicateFile() end },
            { "<leader>wc", function() require('genghis').chmodx() end },
        },
    },
    'arthurxavierx/vim-caser',
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },
    {
        'Wansmer/sibling-swap.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = true,
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
        config = true,
    },

    -- Git
    'tpope/vim-fugitive',
    {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            -- OR 'ibhagwan/fzf-lua',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            suppress_missing_scope = {
                projects_v2 = true,
            }
        },
        init = function()
            vim.treesitter.language.register('markdown', 'octo')
        end,
    },
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
        "chrisgrieser/nvim-various-textobjs",
        lazy = false,
        opts = {
            useDefaultKeymaps = true,
            disabledKeymaps = { "gw", "r" },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        requires = "nvim-treesitter/nvim-treesitter",
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,
                        keymaps = {
                            -- Built-in captures.
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["it"] = "@type",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'single',
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>K"] = "@function.outer",
                            -- ["<leader>dF"] = "@class.outer",
                        },
                    },
                },
            }
        end,
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
