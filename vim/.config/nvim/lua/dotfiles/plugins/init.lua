local M = {}

function M.setup(only_packer)
    require('packer').startup({
        function(use)
            -- `configs.name` is the same as calling `require('dotfiles.plugins.name')`
            local configs = require('dotfiles.utils.helpers').create_lookup('dotfiles.plugins')

            -- Plugin Management
            use 'wbthomason/packer.nvim'
            if (only_packer) then
                print('!!! Packer.nvim was the only plugin loaded !!!')
                return
            end
            use 'loganswartz/vim-plug-updates'

            -- LSP
            use(configs.lspconfig)
            use(configs.null_ls)
            use 'jose-elias-alvarez/typescript.nvim'
            use 'folke/neodev.nvim'
            use(configs.dadbod)
            use 'kristijanhusak/vim-dadbod-ui'
            use(configs.neotest)
            use(configs.dap)

            -- UI / Highlighting
            use(configs.treesitter)
            use 'nvim-treesitter/playground'
            use(configs.comment)
            use(configs.cosmic_ui)
            use(configs.indent_blankline)
            use(configs.telescope)
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
            use 'junegunn/goyo.vim'
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
            use 'junegunn/gv.vim'
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
                'navarasu/onedark.nvim',
                config = function()
                    vim.g.onedark_transparent_background = true
                    vim.g.onedark_italic_comment = false
                end,
            }
            use {
                'loganswartz/selenized.nvim',
                requires = {
                    'rktjmp/lush.nvim',
                },
                config = function()
                    vim.g.selenized_variant = 'bw'
                    vim.cmd.colorscheme('selenized')
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
