local M = {}

function M.setup()
    require('packer').startup({
        function(use)
            -- Plugin Management
            use 'wbthomason/packer.nvim'
            use 'loganswartz/vim-plug-updates'

            -- LSP
            use {
                'williamboman/nvim-lsp-installer',
                requires = { 'rcarriga/nvim-notify' },
            }
            use(require('dotfiles.plugins.lspconfig'))
            use(require('dotfiles.plugins.null-ls'))
            use 'jose-elias-alvarez/typescript.nvim'
            use 'folke/lua-dev.nvim'
            use 'nanotee/sqls.nvim'
            use(require('dotfiles.plugins.dadbod'))
            use 'kristijanhusak/vim-dadbod-ui'
            use {
                'psf/black',
                config = function()
                    vim.g.black_quiet = true
                end,
            }
            use(require('dotfiles.plugins.neotest'))

            -- UI / Highlighting
            use(require('dotfiles.plugins.nvim-treesitter'))
            use 'nvim-treesitter/playground'
            use(require('dotfiles.plugins.comment'))
            use(require('dotfiles.plugins.cosmic-ui'))
            use(require('dotfiles.plugins.indent-blankline'))
            use(require('dotfiles.plugins.telescope'))
            use 'rafcamlet/nvim-luapad'
            use {
                'sudormrfbin/cheatsheet.nvim',
                requires = {
                    'nvim-telescope/telescope.nvim',
                    'nvim-lua/popup.nvim',
                    'nvim-lua/plenary.nvim',
                }
            }
            use(require('dotfiles.plugins.lualine'))
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
            use(require('dotfiles.plugins.nvim-cmp'))
            use 'tpope/vim-surround'
            use 'tpope/vim-speeddating'
            use 'tpope/vim-eunuch'
            use 'arthurxavierx/vim-caser'
            use 'windwp/nvim-ts-autotag'

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
            use(require('dotfiles.plugins.gitsigns'))
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
            use(require('dotfiles.plugins.smart-splits'))

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
                    vim.cmd('colorscheme selenized')
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
