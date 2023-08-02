local M = {}

function M.setup(only_packer)
    require('packer').startup({
        function(use)
            -- `configs.name` is the same as calling `require('dotfiles.plugins.name')`
            local configs = require('dotfiles.utils.helpers').create_lookup('dotfiles.plugins')

            -- Plugin Management
            use 'wbthomason/packer.nvim'
            if only_packer then
                print('!!! Packer.nvim was the only plugin loaded !!!')
                return
            end
            use {
                'loganswartz/plugwatch.nvim',
                config = function()
                    require('plugwatch').setup()
                end,
            }

            -- LSP
            use(configs.lspconfig)
            use {
                'simrat39/rust-tools.nvim',
                after = 'nvim-lspconfig',
                config = function()
                    local rt = require("rust-tools")

                    local utils = require('dotfiles.plugins.lspconfig.utils')
                    local options = utils.generate_opts()

                    rt.setup({
                        server = options,
                    })
                end
            }
            use {
                'saecki/crates.nvim',
                requires = { 'nvim-lua/plenary.nvim' },
                config = function()
                    require('crates').setup()
                end,
            }
            use(configs.null_ls)
            use 'jose-elias-alvarez/typescript.nvim'
            use 'folke/neodev.nvim'
            use(configs.neotest)
            use(configs.dap)
            use {
                "rcarriga/nvim-dap-ui",
                requires = { "mfussenegger/nvim-dap" }
            }
            use {
                'loganswartz/updoc.nvim',
                requires = {
                    'nvim-lua/plenary.nvim',
                    'nvim-treesitter/nvim-treesitter',
                },
                config = function()
                    local updoc = require('updoc')
                    updoc.setup()

                    vim.keymap.set('n', '<leader>ds', updoc.search)
                    vim.keymap.set('n', '<C-k>', updoc.show_hover_links)
                end,
            }

            -- UI / Highlighting
            use(configs.treesitter)
            use(configs.comment)
            use(configs.indent_blankline)
            use(configs.telescope)
            use "princejoogie/dir-telescope.nvim"
            use {
                'stevearc/dressing.nvim',
                config = function()
                    require('dressing').setup({
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
                    })
                end,
            }
            use 'rafcamlet/nvim-luapad'
            use {
                'sudormrfbin/cheatsheet.nvim',
                requires = {
                    'nvim-telescope/telescope.nvim',
                    'nvim-lua/popup.nvim',
                    'nvim-lua/plenary.nvim',
                }
            }
            use(configs.lualine)
            use {
                'nacro90/numb.nvim',
                config = function()
                    require('numb').setup()
                end,
            }
            use {
                'norcalli/nvim-colorizer.lua',
                config = function()
                    require('colorizer').setup()
                end,
            }
            use 'ryanoasis/vim-devicons'
            use {
                'lukas-reineke/virt-column.nvim',
                config = function()
                    require("virt-column").setup()
                    vim.cmd [[ hi! link VirtColumn Comment ]]
                end,
            }
            use 'loganswartz/vim-squint'

            -- Completion
            use(configs.cmp)
            use {
                'ray-x/lsp_signature.nvim',
                config = function()
                    require "lsp_signature".setup({
                        hint_enable = false,
                    })
                end,
            }
            use 'tpope/vim-surround'
            use 'tpope/vim-speeddating'
            use 'tpope/vim-eunuch'
            use 'arthurxavierx/vim-caser'
            use {
                'windwp/nvim-ts-autotag',
                requires = 'nvim-treesitter/nvim-treesitter',
                after = 'nvim-treesitter',
            }

            -- Formatting
            use {
                'FooSoft/vim-argwrap',
                config = function()
                    vim.keymap.set('n', 'gw', ':ArgWrap<CR>')
                    vim.g.argwrap_tail_comma = true
                end,
            }
            use {
                'tibabit/vim-templates',
                config = function()
                    vim.g.tmpl_search_paths = { vim.fn.stdpath('config') .. '/templates' }
                end,
            }
            use {
                'nguyenvukhang/nvim-toggler',
                config = function()
                    -- init.lua
                    require('nvim-toggler').setup({
                        -- removes the default <leader>i keymap
                        remove_default_keybinds = true,
                    })
                    vim.keymap.set({ 'n', 'v' }, '<leader><space>', require('nvim-toggler').toggle)
                end,
            }

            -- Git
            use(configs.gitsigns)
            use 'tpope/vim-fugitive'
            use {
                'rhysd/git-messenger.vim',
                config = function()
                    vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
                    vim.g.git_messenger_popup_content_margins = false
                    vim.keymap.set('n', '<leader>B', ':GitMessenger<CR>', { silent = true, noremap = true })
                end,
            }
            use {
                'tveskag/nvim-blame-line',
                config = function()
                    --[[ vim.g.blameLineGitFormat = '[%h] %an - %ar' ]]
                    vim.keymap.set('n', '<leader>b', ':ToggleBlameLine<CR>', { silent = true, noremap = true })
                end,
            }
            use {
                'ruifm/gitlinker.nvim',
                requires = 'nvim-lua/plenary.nvim',
                config = function()
                    require("gitlinker").setup()
                end,
            }

            -- Window Management
            use 'tpope/vim-vinegar'
            use(configs.smart_splits)

            -- Navigation
            use 'wellle/targets.vim'
            use {
                'joereynolds/place.vim',
                config = function()
                    vim.keymap.set('n', 'ga', '<Plug>(place-insert)')
                    vim.keymap.set('n', 'gb', '<Plug>(place-insert-multiple)')
                end,
            }
            use {
                'julian/vim-textobj-variable-segment',
                requires = 'kana/vim-textobj-user',
                after = 'vim-textobj-user',
            }

            -- Colorschemes
            use {
                'loganswartz/sunburn.nvim',
                requires = {
                    'loganswartz/polychrome.nvim',
                },
                config = function()
                    vim.cmd.colorscheme('sunburn')
                end,
            }
            use {
                'loganswartz/selenized.nvim',
                requires = {
                    'rktjmp/lush.nvim',
                },
                config = function()
                    vim.g.selenized_variant = 'bw'
                end,
            }

            -- Misc
            use 'dstein64/vim-startuptime'
            use 'lambdalisue/suda.vim'
            use 'jghauser/mkdir.nvim'
        end,
        config = {
            display = {
                open_fn = function()
                    return require('packer.util').float()
                end,
            },
        },
    })
end

return M
